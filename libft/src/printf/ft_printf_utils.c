/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_printf_utils.c                                  :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: MZimeris <MZimeris@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/05/15 19:45:36 by MZimeris          #+#    #+#             */
/*   Updated: 2025/05/22 00:53:30 by MZimeris         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "ft_printf.h"

int	is_specifier(char c)
{
	char	*specifiers;

	specifiers = "cspdiuxX%";
	return (ft_strchr(specifiers, c) != NULL);
}

int	is_flag(char c)
{
	char	*flags;

	flags = "-0# +";
	return (ft_strchr(flags, c) != NULL);
}

t_element	*new_empty_element(void)
{
	t_element	*element;

	element = malloc(sizeof(t_element));
	if (!element)
		return (NULL);
	element->specifier = 0;
	element->handler = NULL;
	element->content = NULL;
	element->has_minus = 0;
	element->has_zero = 0;
	element->precision = -1;
	element->width = 0;
	element->has_hash = 0;
	element->has_plus = 0;
	element->has_space = 0;
	return (element);
}

t_element	**create_tab(const char *format)
{
	size_t		total_elements;
	t_element	**elements;
	size_t		i;

	i = 0;
	total_elements = pre_count_elements(format);
	elements = malloc(sizeof(t_element *) * (total_elements + 1));
	if (!elements)
		return (NULL);
	while (i < total_elements)
		elements[i++] = NULL;
	elements[i] = NULL;
	return (elements);
}
