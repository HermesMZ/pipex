/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: mzimeris <mzimeris@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/07/25 14:12:12 by mzimeris          #+#    #+#             */
/*   Updated: 2025/07/25 15:17:52 by mzimeris         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

int	main(int argc, char *argv[])
{
	if (argc < 5)
	{
		ft_putstr_fd("Usage: ./pipex inf cmd1 ... cmd2 outf\n", 2);
		return (1);
	}
	if (pipex(argc, argv) == -1)
	{
		ft_putstr_fd("Error in pipex execution\n", 2);
		return (1);
	}
	return (0);
}
