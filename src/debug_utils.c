/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   debug_utils.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: mzimeris <mzimeris@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/07/25 16:00:06 by mzimeris          #+#    #+#             */
/*   Updated: 2025/07/25 16:22:31 by mzimeris         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

void	print_pipex_info(t_pipex *pipex)
{
	int	i;

	if (!pipex)
	{
		ft_putstr_fd("Pipex structure is NULL\n", 2);
		return ;
	}
	ft_printf("Pipex Info:\n");
	ft_printf("Infile: %s\n", pipex->infile);
	ft_printf("Outfile: %s\n", pipex->outfile);
	ft_printf("Infile FD: %d\n", pipex->infile_fd);
	ft_printf("Outfile FD: %d\n", pipex->outfile_fd);
	if (pipex->cmds)
	{
		i = 0;
		while (pipex->cmds[i])
		{
			ft_printf("Command %d: |%s|\n", i + 1, pipex->cmds[i][0]);
			if (pipex->cmds[i][1])
				ft_printf("Argument 1: |%s|\n", pipex->cmds[i][1]);
			i++;
		}
	}
}
