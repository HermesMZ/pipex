/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.h                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: mzimeris <mzimeris@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/07/25 14:13:46 by mzimeris          #+#    #+#             */
/*   Updated: 2025/08/05 13:13:55 by mzimeris         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef PIPEX_H
# define PIPEX_H

# include <stdio.h>
# include <unistd.h>
# include <stdlib.h>
# include <fcntl.h>
# include <sys/types.h>
# include <sys/wait.h>
# include <stdbool.h>
# include "libft.h"
# include "ft_my_alloc.h"

typedef struct s_pipex
{
	char		**path;
	char		**envp;
	char		*infile;
	char		***cmds;
	char		*outfile;
	int			infile_fd;
	int			outfile_fd;
	t_lalloc	*allocator;
}	t_pipex;

int		pipex(t_pipex *pipex);
t_pipex	*init_pipex(t_pipex *pipex, char *envp[]);
char	***init_cmds(t_lalloc *allocator, int cmd_count);

int		parse_args(t_pipex *pipex, int argc, char *argv[]);

void	free_pipex(t_pipex *pipex);

// Debug
void	debug_print_pipex_info(t_pipex *pipex);
void	debug_argv(int argc, char *argv[]);

#endif /* PIPEX_H */