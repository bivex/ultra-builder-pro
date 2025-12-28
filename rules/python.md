# Python Rules

## Type Hints

- Use type hints for all public functions
- Use `Optional[T]` or `T | None` (3.10+)
- Use `TypedDict` for structured dicts
- Run `mypy --strict` for type checking

## Patterns

```python
# Use dataclasses for data structures
from dataclasses import dataclass

@dataclass
class User:
    id: str
    name: str
    email: str | None = None

# Use Enum for constants
from enum import Enum, auto

class Status(Enum):
    PENDING = auto()
    ACTIVE = auto()
    DELETED = auto()

# Use context managers for resources
with open(path, 'r') as f:
    data = f.read()
```

## Testing

- Use `pytest` (not unittest)
- Use `pytest-cov` for coverage
- Use fixtures over setup/teardown
- Use `httpx` for async HTTP testing

## Common Issues

- Don't use mutable default arguments
- Don't catch bare `except:`
- Don't use `import *`
- Use f-strings over `.format()` or `%`
