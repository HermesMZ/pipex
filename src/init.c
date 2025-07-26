/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   init.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: zoum <zoum@student.42.fr>                  +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/07/25 14:35:13 by mzimeris          #+#    #+#             */
/*   Updated: 2025/07/26 22:38:21 by zoum             ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

void	get_paths_from_envp(t_pipex *pipex, char *envp[])
{
	int		i;
	char	*path_env;

	ft_printf("DEBUG: get_paths_from_envp called\n");
	path_env = NULL;
	i = 0;
	if (!envp)
	{
		ft_printf("DEBUG: envp is NULL!\n");
		pipex->path = NULL;
		return ;
	}
	while (envp[i])
	{
		ft_printf("DEBUG: checking envp[%d]: %.20s...\n", i, envp[i]);
		if (ft_strncmp(envp[i], "PATH=", 5) == 0)
		{
			ft_printf("DEBUG: Found PATH at envp[%d]: %s\n", i, envp[i]);
			path_env = envp[i] + 5;
			break ;
		}
		i++;
	}
	if (!path_env)
	{
		ft_putstr_fd("Error: PATH not found in envp\n", 2);
		pipex->path = NULL;
		return ;
	}
	ft_printf("DEBUG: About to split PATH: %.50s...\n", path_env);
	pipex->path = ft_split(path_env, ':');
	if (!pipex->path)
		ft_putstr_fd("Error: Failed to split PATH\n", 2);
	else
		ft_printf("DEBUG: PATH split successfully, first path: %s\n", pipex->path[0]);
}

t_pipex	*init_pipex(t_pipex *pipex, char *envp[])
{
	ft_printf("Initializing pipex structure\n");
	pipex = malloc(sizeof(t_pipex));
	if (!pipex)
		return (NULL);
	*pipex = (t_pipex){0};
	pipex->infile_fd = -1;
	pipex->outfile_fd = -1;
	get_paths_from_envp(pipex, envp);
	return (pipex);
}

char	***init_cmds(int cmd_count)
{
	char	***cmds;
	int		i;

	ft_printf("Initializing commands array with %d commands\n", cmd_count);
	cmds = malloc(sizeof(char **) * (cmd_count + 1));
	if (!cmds)
		return (NULL);
	i = 0;
	while (i < cmd_count)
	{
		cmds[i] = NULL;
		i++;
	}
	cmds[cmd_count] = NULL;
	return (cmds);
}
