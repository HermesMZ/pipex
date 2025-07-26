/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: zoum <zoum@student.42.fr>                  +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/07/25 14:29:58 by mzimeris          #+#    #+#             */
/*   Updated: 2025/07/27 00:24:32 by zoum             ###   ########.fr       */
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
		free(pipex->infile);
	if (pipex->outfile)
		free(pipex->outfile);
	if (pipex->path)
		free_splitted(pipex->path);
	if (pipex->cmds)
		ft_free_tab(pipex->cmds);
	if (pipex)
	{
		close_fds(pipex);
		free(pipex);
		pipex = NULL;
	}
}
