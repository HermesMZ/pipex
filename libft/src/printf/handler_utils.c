/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   handler_utils.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: MZimeris <MZimeris@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/05/17 20:10:28 by MZimeris          #+#    #+#             */
/*   Updated: 2025/05/17 20:10:31 by MZimeris         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "ft_printf.h"

static t_handler	find_format_handler(char specifier)
{
	const t_format	g_format_handlers[] = {
	{'c', handle_char},
	{'s', handle_str},
	{'d', handle_number},
	{'i', handle_number},
	{'u', handle_number},
	{'x', handle_hex},
	{'X', handle_hex},
	{'p', handle_pointer},
	{'%', handle_char},
	{'\0', NULL}
	};
	const t_format	*current = g_format_handlers;

	while (current->specifier != '\0')
	{
		if (current->specifier == specifier)
		{
			return (current->handler);
		}
		current++;
	}
	return (NULL);
}

void	format_finder(t_element **elements)
{
	size_t	i;

	i = 0;
	while (elements[i])
	{
		if (elements[i]->handler == NULL)
			elements[i]->handler = find_format_handler(elements[i]->specifier);
		i++;
	}
}

int	has_option(t_element *element)
{
	return (element->has_minus || element->has_zero || element->precision > -1
		|| element-> width || element->has_hash || element->has_plus
		|| element->has_space);
}

char	get_padding_char(t_element *element)
{
	char	padding_char;

	padding_char = ' ';
	if (element->has_zero && !element->has_minus)
	{
		if (element->specifier == 'd' || element->specifier == 'i'
			|| element->specifier == 'u' || element->specifier == 'x'
			|| element->specifier == 'X' || element->specifier == 'p')
		{
			if (element->precision == -1)
				padding_char = '0';
		}
	}
	return (padding_char);
}
