/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex_bonus.h                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: zoum <zoum@student.42.fr>                  +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/07/25 14:13:46 by mzimeris          #+#    #+#             */
/*   Updated: 2025/08/11 21:13:55 by zoum             ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef PIPEX_BONUS_H
# define PIPEX_BONUS_H

# include "pipex.h"

int		wait_for_children(void);
int		here_doc(t_pipex *pipex, int argc, char *argv[]);
int		here_doc_parse_args(t_pipex *pipex, int argc, char *argv[]);
int		setup_heredoc_redirect(t_pipex *pipex, int i, int pipe_fd[2], char *outfile);
void	here_doc_unlink(t_pipex *pipex);

#endif /* PIPEX_BONUS_H */