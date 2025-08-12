/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   here_doc_bonus.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: zoum <zoum@student.42.fr>                  +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/08/05 18:44:11 by mzimeris          #+#    #+#             */
/*   Updated: 2025/08/11 21:13:55 by zoum             ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex_bonus.h"

void	here_doc_unlink(t_pipex *pipex)
{
	if (strcmp(pipex->infile, "here_doc") == 0)
	{
		if (unlink("here_doc") < 0)
			perror("Error unlinking here_doc file");
	}
}

static void	setup_heredoc_output(char *outfile)
{
	int	outfile_fd;
	int	null_fd;

	// For heredoc, always use append mode
	outfile_fd = open(outfile, O_WRONLY | O_CREAT | O_APPEND, 0644);
	if (outfile_fd < 0)
	{
		perror(outfile);
		null_fd = open("/dev/null", O_WRONLY);
		if (null_fd >= 0)
		{
			dup2(null_fd, STDOUT_FILENO);
			close(null_fd);
		}
	}
	else
	{
		dup2(outfile_fd, STDOUT_FILENO);
		close(outfile_fd);
	}
}

int	check_heredoc_fd(t_pipex *pipex)
{
	int	infile_fd;
	int	outfile_fd;

	infile_fd = open("here_doc", O_RDONLY);
	if (infile_fd < 0)
	{
		perror("here_doc");
		return (-1);
	}
	// Just verify that output file can be opened (in append mode for heredoc)
	outfile_fd = open(pipex->outfile, O_WRONLY | O_CREAT | O_APPEND, 0644);
	if (outfile_fd < 0)
	{
		perror(pipex->outfile);
		close(infile_fd);
		return (-2);
	}
	close(infile_fd);
	close(outfile_fd);
	return (0);
}

int	setup_heredoc_redirect(t_pipex *pipex, int i, int pipe_fd[2], char *outfile)
{
	if (pipex->cmds[i + 1] != NULL)
	{
		// Use pipe for intermediate commands
		dup2(pipe_fd[1], STDOUT_FILENO);
		close(pipe_fd[0]);
		close(pipe_fd[1]);
	}
	else
	{
		// Use append mode for final output in heredoc
		setup_heredoc_output(outfile);
	}
	return (0);
}

int	exec_child_bonus(t_pipex *pipex, int i, int in_fd, int pipe_fd[2])
{
	setup_input_redirect(in_fd);
	if (setup_heredoc_redirect(pipex, i, pipe_fd, pipex->outfile) < 0)
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

int	exec_bonus(t_pipex *pipex, int i, int in_fd)
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
		return (exec_child_bonus(pipex, i, in_fd, pipe_fd));
	}
	if (in_fd > 0)
		close(in_fd);
	if (pipex->cmds[i + 1] != NULL)
		return (close(pipe_fd[1]), pipe_fd[0]);
	return (0);
}

int	pipex_bonus(t_pipex *pipex)
{
	int	i;
	int	in_fd;
	int	last_exit_status;
	int	outfile_test;
	int	outfile_error;

	i = 0;
	outfile_error = 0;
	
	// Test if output file can be created/written to (with append mode for heredoc)
	outfile_test = open(pipex->outfile, O_WRONLY | O_CREAT | O_APPEND, 0644);
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
		in_fd = exec_bonus(pipex, i, in_fd);
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

int	here_doc_parse_args(t_pipex *pipex, int argc, char *argv[])
{
	int	i;

	i = 0;
	pipex->outfile = ft_my_malloc(pipex->allocator,
			ft_strlen(argv[argc - 1]) + 1);
	if (!pipex->outfile)
		return (-1);
	ft_strlcpy(pipex->outfile, argv[argc - 1], ft_strlen(argv[argc - 1]) + 1);
	pipex->cmds = init_cmds(pipex->allocator, argc - 4);
	if (!pipex->cmds)
		return (-1);
	while (i < argc - 4)
	{
		if (parse_one_command(pipex, argv[i + 3], pipex->cmds, i) < 0)
			return (-1);
		i++;
	}
	if (check_heredoc_fd(pipex) < 0)
		return (-1);
	return (0);
}

int	here_doc(t_pipex *pipex, int argc, char *argv[])
{
	char	*line;
	int		temp_fd;

	temp_fd = open("here_doc", O_WRONLY | O_CREAT | O_TRUNC, 0644);
	if (temp_fd < 0)
		return (perror("here_doc"), -1);
	while (1)
	{
		line = get_next_line(STDIN_FILENO);
		if (!line)
			break ;
		if (ft_strncmp(line, argv[2], ft_strlen(argv[2])) == 0
			&& line[ft_strlen(argv[2])] == '\n')
		{
			free(line);
			break ;
		}
		write(temp_fd, line, ft_strlen(line));
		free(line);
	}
	close(temp_fd);
	get_next_line(-1);
	if (here_doc_parse_args(pipex, argc, argv) < 0)
		return (-1);
	return (0);
}
