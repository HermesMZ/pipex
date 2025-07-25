NAME = pipex
CC = cc
CFLAGS = -Wall -Wextra -Werror -g3
SRCS_DIR = src
OBJS_DIR = objs
INCLUDES_DIR = includes
LIBFT_DIR = libft
LIBFT = $(LIBFT_DIR)/libft.a

SRCS = \
	init.c \
	main.c \
	parsing.c \
	pipex.c \
	utils.c \
	debug_utils.c \

SRCS_PATH = $(addprefix $(SRCS_DIR)/, $(SRCS))
OBJS = $(SRCS_PATH:$(SRCS_DIR)/%.c=$(OBJS_DIR)/%.o)

INCLUDES = -I $(INCLUDES_DIR) -I $(LIBFT_DIR)/includes

all: $(LIBFT) $(LIBMLX) $(NAME)

$(NAME): $(OBJS) $(LIBFT)
	$(CC) $(CFLAGS) $(OBJS) $(LIBFT) -o $(NAME)

$(OBJS_DIR)/%.o: $(SRCS_DIR)/%.c | $(OBJS_DIR)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(OBJS_DIR):
	mkdir -p $(OBJS_DIR)

$(LIBFT):
	@echo "Construction de libft.a..."
	@$(MAKE) -C $(LIBFT_DIR)

clean:
	@echo "Nettoyage des fichiers objets..."
	@rm -rf $(OBJS_DIR)

fclean: clean
	@echo "Nettoyage de $(NAME) et de libft..."
	@rm -f $(NAME)
	@$(MAKE) -C $(LIBFT_DIR) fclean

re: fclean all

.PHONY: all clean fclean re