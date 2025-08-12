/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: zoum <zoum@student.42.fr>                  +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/07/25 14:12:34 by mzimeris          #+#    #+#             */
/*   Updated: 2025/08/11 21:13:55 by zoum             ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"
#include <signal.h>

// valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --trace-children=yes --track-fds=yes ./pipex Makefile cat "wc -l" outfile

// ➜  pipex git:(main) ✗ timeout 3 strace -f -e trace=pipe,dup2,close,wait4 ./pipex test_file.txt "cat" "wc -l" output.txt 2>&1 | head -30

int	exec_child(t_pipex *pipex, int i, int in_fd, int pipe_fd[2])
{
	setup_input_redirect(in_fd);
	if (setup_output_redirect(pipex, i, pipe_fd, pipex->outfile) < 0)
	{
		free_pipex(pipex);
		exit(1);
	}
	if (check_command(pipex, pipex->cmds[i][0], i) < 0)
	{
		ft_putstr_fd("command not found: ", 2);
		ft_putendl_fd(pipex->cmds[i][0], 2);
		free_pipex(pipex);
		exit(127);
	}
	execve(pipex->cmds[i][0], pipex->cmds[i], pipex->envp);
	perror("execve");
	free_pipex(pipex);
	exit(127);
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
		return (ft_putstr_fd("Error: Fork failed\n", 2), -1);
	if (pid == 0)
	{
		return (exec_child(pipex, i, in_fd, pipe_fd));
	}
	if (in_fd > 0)
		close(in_fd);
	if (pipex->cmds[i + 1] != NULL)
		return (close(pipe_fd[1]), pipe_fd[0]);
	return (0);
}

int	wait_for_children(void)
{
	int	status;
	int	last_exit_status;

	last_exit_status = 0;
	while (wait(&status) > 0)
	{
		if (WIFEXITED(status))
		{
			last_exit_status = WEXITSTATUS(status);
		}
		else if (WIFSIGNALED(status))
		{
			// Handle processes terminated by signals
			int sig = WTERMSIG(status);
			if (sig != SIGPIPE)
			{
				// Non-SIGPIPE signals indicate real errors
				last_exit_status = 128 + sig;
			}
		}
	}
	// In a pipeline, bash returns the exit status of the last command
	return (last_exit_status);
}

int	pipex(t_pipex *pipex)
{
	int	i;
	int	in_fd;
	int	last_exit_status;
	int	outfile_test;
	int	outfile_error;

	i = 0;
	outfile_error = 0;
	
	// Test if output file can be created/written to
	outfile_test = open(pipex->outfile, O_WRONLY | O_CREAT | O_TRUNC, 0644);
	if (outfile_test < 0)
	{
		perror(pipex->outfile);
		outfile_error = 1; // Remember the error but continue execution
	}
	else
	{
		close(outfile_test);
	}
	
	// Open input file locally in parent process
	in_fd = open(pipex->infile, O_RDONLY);
	if (in_fd < 0)
	{
		perror(pipex->infile);
		in_fd = -1; // Will redirect to /dev/null in child
	}
	
	while (pipex->cmds[i])
	{
		in_fd = exec(pipex, i, in_fd);
		if (in_fd < 0)
			return (-1);
		i++;
	}
	
	last_exit_status = wait_for_children();
	
	// If there was an output file error, return 1 regardless of command exit status
	if (outfile_error)
		return (1);
		
	return (last_exit_status);
}
