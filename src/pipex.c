/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: mzimeris <mzimeris@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/07/25 14:12:34 by mzimeris          #+#    #+#             */
/*   Updated: 2025/08/04 18:14:27 by mzimeris         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

// $> ./pipex infile "ls -l" "wc -l" outfile
// Devrait être identique à < infile ls -l | wc -l > outfile
// $> ./pipex infile "grep a1" "wc -w" outfile
// Devrait être identique à < infile grep a1 | wc -w > outfile

// structure pour stocker les arguments
// char * infile
// char ***cmds
// char * outfile

// flow :
// 2. créer un pipe
// 3. fork pour cmd
// recommencer 2 et 3 pour chaque commande
// 4. ouvrir outfile
// 5. creer un pipe
// 6. envoyer le résultat de la dernière commande dans outfile

// creer un pipe
// fork
// dans le fils : (PID == 0)
// - rediriger l'entrée standard vers infile
// - rediriger la sortie standard vers le pipe
// dans le père : (PID > 0)
// - rediriger l'entrée du pipe vers la sortie standard
// attendre la fin du fils

// ft_exec()
// {
// 	pipe()
// 	fork()
// 	if (child)
// 	{
// 		dup2()
// 		execve()
// 	}
// 	else
// 	{
// 		close()
// 	}
// }

int	exec_child(t_pipex *pipex, int i, int in_fd, int pipe_fd[2])
{
	if (in_fd != 0)
	{
		dup2(in_fd, STDIN_FILENO);
		close(in_fd);
	}
	if (pipex->cmds[i + 1] != NULL)
	{
		dup2(pipe_fd[1], STDOUT_FILENO);
		close(pipe_fd[0]);
		close(pipe_fd[1]);
	}
	else
	{
		if (pipex->outfile_fd < 0)
		{
			ft_putstr_fd("Error: Outfile invalid\n", 2);
			return (-1);
		}
		dup2(pipex->outfile_fd, STDOUT_FILENO);
		close(pipex->outfile_fd);
	}
	execve(pipex->cmds[i][0], pipex->cmds[i], NULL);
	perror("execve");
	exit(1);
}

int	exec(t_pipex *pipex, int i, int in_fd)
{
	int	pid;
	int	pipe_fd[2];

	pipe_fd[0] = -1;
	pipe_fd[1] = -1;
	if (pipex->cmds[i + 1] != NULL && pipe(pipe_fd) < 0)
		return ((ft_putstr_fd("Error: Pipe creation failed\n", 2)), -1);
	pid = fork();
	if (pid < 0)
	{
		ft_putstr_fd("Error: Fork failed\n", 2);
		return (-1);
	}
	if (pid == 0)
		return (exec_child(pipex, i, in_fd, pipe_fd));
	if (in_fd != 0)
		close(in_fd);
	if (pipex->cmds[i + 1] != NULL)
	{
		close(pipe_fd[1]);
		return (pipe_fd[0]);
	}
	return (0);
}

int	pipex(t_pipex *pipex)
{
	int	i;
	int	in_fd;

	i = 0;
	in_fd = 0;
	while (pipex->cmds[i])
	{
		in_fd = exec(pipex, i, in_fd);
		if (in_fd < 0)
			return (-1);
		i++;
	}
	return (0);
}
