/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: mzimeris <mzimeris@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/07/25 14:12:34 by mzimeris          #+#    #+#             */
/*   Updated: 2025/08/05 16:06:11 by mzimeris         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

void	setup_input_redirect(int in_fd)
{
	int	null_fd;

	if (in_fd > 0)
	{
		dup2(in_fd, STDIN_FILENO);
		close(in_fd);
	}
	else if (in_fd == -1)
	{
		null_fd = open("/dev/null", O_RDONLY);
		if (null_fd >= 0)
		{
			dup2(null_fd, STDIN_FILENO);
			close(null_fd);
		}
	}
}

int	setup_output_redirect(t_pipex *pipex, int i, int pipe_fd[2])
{
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
	return (0);
}

int	exec_child(t_pipex *pipex, int i, int in_fd, int pipe_fd[2])
{
	setup_input_redirect(in_fd);
	if (setup_output_redirect(pipex, i, pipe_fd) < 0)
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
		return (exec_child(pipex, i, in_fd, pipe_fd));
	if (in_fd > 0)
		close(in_fd);
	if (pipex->cmds[i + 1] != NULL)
		return (close(pipe_fd[1]), pipe_fd[0]);
	return (0);
}

int	pipex(t_pipex *pipex)
{
	int	i;
	int	in_fd;
	int	status;
	int	last_exit_status;

	i = 0;
	in_fd = pipex->infile_fd;
	last_exit_status = 0;
	while (pipex->cmds[i])
	{
		in_fd = exec(pipex, i, in_fd);
		if (in_fd < 0)
			return (-1);
		i++;
	}
	while (wait(&status) > 0)
	{
		if (WIFEXITED(status))
			last_exit_status = WEXITSTATUS(status);
	}
	return (last_exit_status);
}
