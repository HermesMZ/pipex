/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_printf.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: mzimeris <mzimeris@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/05/06 12:14:50 by mzimeris          #+#    #+#             */
/*   Updated: 2025/05/06 12:14:53 by mzimeris         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "ft_printf.h"

static void	free_elements(t_element **elements)
{
	size_t	i;

	i = 0;
	if (elements)
	{
		while (elements[i] != NULL)
		{
			if (elements[i]->content)
			{
				free(elements[i]->content);
				elements[i]->content = NULL;
			}
			free(elements[i]);
			elements[i] = NULL;
			i++;
		}
		free(elements);
		elements = NULL;
	}
}

static size_t	elements_count(t_element **elements)
{
	size_t	count;

	count = 0;
	while (elements[count])
		count++;
	return (count);
}

static size_t	print_elements(t_element **elements)
{
	size_t	total_printed;
	size_t	i;
	size_t	total_elements;

	i = 0;
	total_printed = 0;
	total_elements = elements_count(elements);
	while (i < total_elements)
	{
		if (elements[i]->handler)
			total_printed += elements[i]->handler(elements[i]);
		i++;
	}
	return (total_printed);
}

int	ft_printf(const char *format, ...)
{
	size_t		total_printed;
	va_list		al;
	t_element	**elements;

	total_printed = 0;
	elements = NULL;
	if (!format)
		return (-1);
	if (validate_format_string(format) == 0)
	{
		va_start(al, format);
		elements = parse_format_string(format, al);
		va_end(al);
		if (!elements)
			return (-1);
		format_finder(elements);
		total_printed = print_elements(elements);
		free_elements(elements);
	}
	else
		return (-1);
	return (total_printed);
}
