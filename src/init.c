/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   init.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: mzimeris <mzimeris@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/07/25 14:35:13 by mzimeris          #+#    #+#             */
/*   Updated: 2025/07/25 15:56:05 by mzimeris         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

t_pipex	*init_pipex(t_pipex *pipex)
{
	ft_printf("Initializing pipex structure\n");
	pipex = malloc(sizeof(t_pipex));
	if (!pipex)
		return (NULL);
	*pipex = (t_pipex){0};
	pipex->infile_fd = -1;
	pipex->outfile_fd = -1;
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
