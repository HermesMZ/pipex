/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   parsing.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: mzimeris <mzimeris@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/07/25 14:38:18 by mzimeris          #+#    #+#             */
/*   Updated: 2025/08/04 18:14:12 by mzimeris         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

int	check_files_rights(t_pipex *pipex)
{
	if (access(pipex->infile, F_OK | R_OK) == -1)
		return (ft_putstr_fd("Error: Cannot access files\n", 1), -2);
	pipex->infile_fd = open(pipex->infile, O_RDONLY);
	if (pipex->infile_fd < 0)
		return (-2);
	if (access(pipex->outfile, F_OK == -1))
		pipex->outfile_fd = open(pipex->outfile, O_WRONLY | O_CREAT
				| O_TRUNC, 0644);
	if (access(pipex->outfile, W_OK) == -1)
		return (-2);
	if (pipex->outfile_fd < 0)
		return (-2);
	return (0);
}

char	*check_full_path(char *cmd, char *path_dir)
{
	char	*full_path;
	char	*path_with_slash;

	if (!cmd || !path_dir)
		return (NULL);
	path_with_slash = ft_strjoin(path_dir, "/");
	if (!path_with_slash)
		return (NULL);
	full_path = ft_strjoin(path_with_slash, cmd);
	free(path_with_slash);
	if (!full_path)
		return (NULL);
	if (access(full_path, F_OK | X_OK) == 0)
		return (full_path);
	free(full_path);
	return (NULL);
}

int	check_command(t_pipex *pipex, char *cmd, int index)
{
	int		i;
	char	*full_path;

	if (!cmd || !pipex || !pipex->path)
		return (-1);
	if (ft_strchr(cmd, '/') != NULL && access(cmd, F_OK | X_OK) == 0)
	{
		free(pipex->cmds[index][0]);
		pipex->cmds[index][0] = ft_strdup(cmd);
		return (0);
	}
	i = -1;
	while (pipex->path[++i])
	{
		full_path = check_full_path(cmd, pipex->path[i]);
		if (full_path)
		{
			free(pipex->cmds[index][0]);
			pipex->cmds[index][0] = full_path;
			return (0);
		}
	}
	return (-1);
}

int	parse_one_command(t_pipex *pipex, char *cmd, char ***cmds, int index)
{
	char	**args;

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
	if (check_command(pipex, args[0], index) < 0)
		return (-1);
	return (0);
}

int	parse_args(t_pipex *pipex, int argc, char *argv[])
{
	int	i;

	i = 0;
	pipex->infile = ft_strdup(argv[1]);
	if (!pipex->infile)
		return (-1);
	pipex->outfile = ft_strdup(argv[argc - 1]);
	if (!pipex->outfile)
		return (-1);
	pipex->cmds = init_cmds(argc - 3);
	if (!pipex->cmds)
		return (-1);
	while (i < argc - 3)
	{
		if (parse_one_command(pipex, argv[i + 2], pipex->cmds, i) < 0)
			return (-1);
		i++;
	}
	if (check_files_rights(pipex) < 0)
		return (-1);
	return (0);
}
