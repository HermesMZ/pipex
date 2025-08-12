/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: zoum <zoum@student.42.fr>                  +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/07/25 14:12:12 by mzimeris          #+#    #+#             */
/*   Updated: 2025/08/11 19:08:21 by zoum             ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"
#include <signal.h>

int	main(int argc, char *argv[], char *envp[])
{
	t_pipex	*pipex_data;
	int		exit_status;

	// Ignore SIGPIPE to handle broken pipes gracefully
	signal(SIGPIPE, SIG_IGN);
	
	if (argc != 5)
		return (ft_putstr_fd("Usage: ./pipex infile cmd1 cmd2 outfile\n",
				2), 1);
	pipex_data = init_pipex(NULL, envp);
	if (!pipex_data)
		return (1);
	if (parse_args(pipex_data, argc, argv) < 0)
		return (free_pipex(pipex_data), 1);
	exit_status = pipex(pipex_data);
	free_pipex(pipex_data);
	if (exit_status == -1)
		return (1);
	return (exit_status);
}
