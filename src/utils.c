/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: mzimeris <mzimeris@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/07/25 14:29:58 by mzimeris          #+#    #+#             */
/*   Updated: 2025/07/25 16:19:11 by mzimeris         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

void	ft_free_tab(char ***tab)
{
	int	i;
	int	j;

	if (!tab)
		return ;
	i = 0;
	while (tab[i])
	{
		j = 0;
		while (tab[i][j])
			free(tab[i][j++]);
		free(tab[i]);
		i++;
	}
	free(tab);
}

void	close_fds(t_pipex *pipex)
{
	if (pipex->infile_fd >= 0)
		close(pipex->infile_fd);
	if (pipex->outfile_fd >= 0)
		close(pipex->outfile_fd);
}

void	free_pipex(t_pipex *pipex)
{
	if (!pipex)
		return ;
	if (pipex->infile)
	{
		free(pipex->infile);
		pipex->infile = NULL;
	}
	if (pipex->outfile)
	{
		free(pipex->outfile);
		pipex->outfile = NULL;
	}
	if (pipex->cmds)
	{
		ft_free_tab(pipex->cmds);
		pipex->cmds = NULL;
	}
	if (pipex)
	{
		close_fds(pipex);
		free(pipex);
		pipex = NULL;
	}
}
