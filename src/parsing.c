/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   parsing.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: mzimeris <mzimeris@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/07/25 14:38:18 by mzimeris          #+#    #+#             */
/*   Updated: 2025/07/25 16:21:06 by mzimeris         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

int	check_files_rights(t_pipex *pipex)
{
	ft_printf("Checking rights for infile: %s and outfile: %s\n",
		pipex->infile, pipex->outfile);
	if (access(pipex->infile, F_OK | R_OK) == -1
		|| access(pipex->outfile, F_OK | W_OK) == -1)
		return (ft_putstr_fd("Error: Cannot access infile or outfile\n", 1), -2);
	pipex->infile_fd = open(pipex->infile, O_RDONLY);
	if (pipex->infile_fd < 0)
		return (free_pipex(pipex), -2);
	pipex->outfile_fd = open(pipex->outfile, O_WRONLY | O_CREAT
			| O_TRUNC, 0644);
	if (pipex->outfile_fd < 0)
		return (free_pipex(pipex), -2);
	return (0);
}

int	check_commands(t_pipex *pipex)
{
	int	i;

	ft_printf("Checking commands rights\n");
	i = 0;
	while (pipex->cmds[i])
	{
		if (access(pipex->cmds[i][0], F_OK) == -1)
		{
			ft_putstr_fd("Error: Command not found: ", 1);
			ft_putstr_fd(pipex->cmds[i][0], 2);
			ft_putstr_fd("\n", 2);
			return (free_pipex(pipex), -3);
		}
		else if (access(pipex->cmds[i][0], X_OK) == -1)
		{
			ft_putstr_fd("Error: Command not executable: ", 1);
			ft_putstr_fd(pipex->cmds[i][0], 2);
			ft_putstr_fd("\n", 2);
			return (free_pipex(pipex), -3);
		}
		i++;
	}
	return (0);
}

int	parse_one_command(char *cmd, char ***cmds, int index)
{
	char	**args;

	ft_printf("Parsing command: %s\n", cmd);
	if (index < 0 || !cmds || !cmd)
		return (-1);
	args = NULL;
	if (ft_strchr(cmd, ' ') == NULL)
	{
		args = malloc(sizeof(char *) * 2);
		if (!args)
			return (-1);
		args[0] = ft_strdup(cmd);
		if (!args[0])
			return (free(args), -1);
		args[1] = NULL;
	}
	else
		args = ft_split(cmd, ' ');
	if (!args)
		return (-1);
	cmds[index] = args;
	return (0);
}

int	parse_args(int argc, char *argv[], t_pipex *pipex)
{
	int	i;

	ft_printf("Parsing arguments\n");
	i = 0;
	pipex->infile = ft_strdup(argv[1]);
	if (!pipex->infile)
		return (-1);
	pipex->outfile = ft_strdup(argv[argc - 1]);
	if (!pipex->outfile)
		return (free_pipex(pipex), -1);
	pipex->cmds = init_cmds(argc - 3);
	if (!pipex->cmds)
		return (free_pipex(pipex), -1);
	while (i < argc - 3)
	{
		if (parse_one_command(argv[i + 2], pipex->cmds, i) < 0)
			return (free_pipex(pipex), -1);
		i++;
	}
	print_pipex_info(pipex);
	if (check_files_rights(pipex) < 0 || check_commands(pipex) < 0)
		return (-1);
	return (0);
}
