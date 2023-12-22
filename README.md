# Web Application Template Files

This repository is dedicated to providing a set of template files for quickly setting up a basic web application with the following Python libraries:
- [Poetry](https://python-poetry.org/)
- [ReactPy](https://github.com/reactive-python/reactpy) | [Docs](https://reactpy.dev/docs/index.html)
- [Supabase](https://supabase.com/) | [Docs](https://supabase.com/docs/reference/python/introduction)


## Getting Started
Simply, duplicate the branch, rename the directory, navigate to it, and amend the following files in the code editor of choice:

- `docker-compose.yaml` - change the `container_name`
- `Dockerfile` - the Python version in the `builder`
- `pyproject.toml` - the `name`, `description`, `version`, and `authors`
- `.env` - update the variable values

Once done, run the following commands in the main directory:
```cmd
# Creates poetry.lock file
poetry install

# Creates the docker image and runs the container
docker-compose up --build
```
