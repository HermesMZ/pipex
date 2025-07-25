/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   check_and_count.c                                  :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: MZimeris <MZimeris@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/05/15 02:30:35 by MZimeris          #+#    #+#             */
/*   Updated: 2025/05/15 02:30:41 by MZimeris         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "ft_printf.h"

static int	validate_flags_spec(const char *format)
{
	size_t	i;

	i = 0;
	if (format[i] == '%')
		return (1);
	while (is_flag(format[i]))
		i++;
	while (ft_isdigit(format[i]))
		i++;
	if (format[i] == '.')
	{
		i++;
		while (ft_isdigit(format[i]))
			i++;
	}
	if (is_specifier(format[i]))
		return (i + 1);
	else
		return (0);
}

int	validate_format_string(const char *format)
{
	size_t	i;
	int		specifier_len;

	i = 0;
	while (format[i] != '\0')
	{
		if (format[++i] == '%')
		{
			if (format[i] == '%')
			{
				i++;
				continue ;
			}
			if (format[i] == '\0')
				return (-1);
			specifier_len = validate_flags_spec(&format[i]);
			if (specifier_len > 0)
				i += specifier_len;
			else
				return (-1);
		}
		else
			i++;
	}
	return (0);
}

size_t	pre_count_elements(const char *format)
{
	size_t	count;
	size_t	i;

	count = 0;
	i = 0;
	while (format[i] != '\0')
	{
		if (format[i] == '%')
		{
			count++;
			i++;
			i += validate_flags_spec(&format[i]);
		}
		else
		{
			count++;
			while (format[i] != '\0' && format[i] != '%')
				i++;
		}
	}
	return (count);
}
