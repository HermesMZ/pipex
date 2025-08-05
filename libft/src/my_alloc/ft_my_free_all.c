/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_my_free_all.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: mzimeris <mzimeris@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/08/05 12:58:47 by mzimeris          #+#    #+#             */
/*   Updated: 2025/08/05 13:13:54 by mzimeris         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "ft_my_alloc.h"

void	*ft_my_free_all(t_lalloc *lalloc)
{
	t_my_malloc	*current;
	t_my_malloc	*next;
	void		*ptr;

	if (!lalloc)
		return (NULL);
	current = lalloc->head;
	lalloc->head = NULL;
	lalloc->total_allocated = 0;
	lalloc->total_freed = 0;
	while (current)
	{
		next = current->next;
		ptr = current->ptr;
		free(current);
		free(ptr);
		current = next;
	}
	return (NULL);
}
