/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.h                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: zoum <zoum@student.42.fr>                  +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/07/25 14:13:46 by mzimeris          #+#    #+#             */
/*   Updated: 2025/07/27 00:24:54 by zoum             ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef PIPEX_H
# define PIPEX_H

// debug
# include <stdio.h>
// debug

# include <unistd.h>
# include <stdlib.h>
# include <fcntl.h>
# include <sys/types.h>
# include <sys/wait.h>
# include <stdbool.h>
# include "libft.h"

typedef struct s_pipex
{
	char	**path;
	char	*infile;
	char	***cmds;
	char	*outfile;
	int		infile_fd;
	int		outfile_fd;
}	t_pipex;

int		pipex(t_pipex *pipex);
t_pipex	*init_pipex(t_pipex *pipex, char *envp[]);
char	***init_cmds(int cmd_count);

int		parse_args(t_pipex *pipex, int argc, char *argv[]);

void	free_pipex(t_pipex *pipex);

// Debug
void	print_pipex_info(t_pipex *pipex);

#endif /* PIPEX_H */