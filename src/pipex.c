/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: zoum <zoum@student.42.fr>                  +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/07/25 14:12:34 by mzimeris          #+#    #+#             */
/*   Updated: 2025/07/26 23:00:06 by zoum             ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

// $> ./pipex infile "ls -l" "wc -l" outfile
// Devrait être identique à < infile ls -l | wc -l > outfile
// $> ./pipex infile "grep a1" "wc -w" outfile
// Devrait être identique à < infile grep a1 | wc -w > outfile

// parsing des arguments
//	check infile rights
//	check cmd1 rights
//	check cmd2 rights
//	check outfile rights

// structure pour stocker les arguments
// char * infile
// char ***cmds
// char * outfile

// flow :
// 1. ouvrir infile	ou lire here_doc
// 2. créer un pipe
// 3. fork pour cmd
// recommencer 2 et 3 pour chaque commande
// 4. ouvrir outfile
// 5. creer un pipe
// 6. envoyer le résultat de la dernière commande dans outfile

int	pipex(t_pipex *pipex)
{
	printf("Infile: %s\n", pipex->infile);
	return (0);
}
