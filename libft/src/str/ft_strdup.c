/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strdup.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: MZimeris <MZimeris@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/04/30 23:14:26 by MZimeris          #+#    #+#             */
/*   Updated: 2025/04/30 23:14:30 by MZimeris         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

// if (!s)
// 	return (NULL);
#include "libft.h"

char	*ft_strdup(const char *s)
{
	int		i;
	char	*temp;

	temp = (char *)malloc(sizeof(char) * (ft_strlen(s) + 1));
	if (!temp)
		return (NULL);
	i = 0;
	while (s[i])
	{
		temp[i] = s[i];
		i++;
	}
	temp[i] = '\0';
	return (temp);
}
