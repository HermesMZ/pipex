/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_printf.h                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: mzimeris <mzimeris@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/04/29 14:07:41 by mzimeris          #+#    #+#             */
/*   Updated: 2025/06/11 16:57:31 by mzimeris         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef FT_PRINTF_H
# define FT_PRINTF_H

# include <stdlib.h>
# include <string.h>
# include <unistd.h>
# include <stdarg.h>
# include "libft.h"

typedef struct s_element	t_element;

typedef struct s_element
{
	char	specifier;
	int		(*handler)(t_element *);
	void	*content;
	int		has_minus;
	int		has_zero;
	int		precision;
	int		width;
	int		has_hash;
	int		has_plus;
	int		has_space;
}	t_element;

typedef int					(*t_handler)(t_element *);

typedef struct s_format
{
	char		specifier;
	t_handler	handler;
}	t_format;

int			ft_printf(const char *format, ...);

//check_input
int			validate_format_string(const char *format);
size_t		pre_count_elements(const char *format);

//parsing
t_element	**parse_format_string(const char *format, va_list args);
size_t		arg_parsing(const char *format, t_element **elements,
				va_list al, size_t *j);
size_t		flag_parsing(const char *format, t_element *element);
void		format_finder(t_element **elements);

//handlers
int			handle_pointer(t_element *element);
int			handle_hex(t_element *element);
int			handle_number(t_element *element);
int			handle_char(t_element *element);
int			handle_str(t_element *element);

//options
char		*handle_options(t_element *element);
char		*apply_precision(t_element *element, char *str);
char		*apply_precision_nbr(t_element *element, char *str);
char		*apply_padding_width(t_element *element, char *str,
				char padding_char);

//special cases
int			handle_null_char_with_padding(t_element *element);
char		*handle_null_string(t_element *element, char *str);

//utils
int			is_specifier(char c);
int			is_flag(char c);
int			has_option(t_element *element);
char		get_padding_char(t_element *element);
t_element	*new_empty_element(void);
t_element	**create_tab(const char *format);

#endif /*FT_PRINTF_H*/
