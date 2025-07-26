/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: zoum <zoum@student.42.fr>                  +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/07/25 14:12:12 by mzimeris          #+#    #+#             */
/*   Updated: 2025/07/27 00:01:28 by zoum             ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

int	main(int argc, char *argv[], char *envp[])
{
	t_pipex	*pipex_data;

	if (argc < 5)
	{
		ft_putstr_fd("Usage: ./pipex inf cmd1 ... cmd2 outf\n", 2);
		return (1);
	}
	pipex_data = init_pipex(NULL, envp);
	if (!pipex_data)
		return (1);
	if (parse_args(pipex_data, argc, argv) < 0)
		return (free_pipex(pipex_data), 1);
	if (pipex(pipex_data) == -1)
	{
		ft_putstr_fd("Error in pipex execution\n", 2);
		return (1);
	}
	if (pipex_data)
		free_pipex(pipex_data);
	return (0);
}
