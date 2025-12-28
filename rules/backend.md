# Backend Rules

## API Design

- Use RESTful conventions or GraphQL
- Version APIs (`/api/v1/`)
- Consistent error format:
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email is required",
    "field": "email"
  }
}
```

## Security

- Validate all input (never trust client)
- Use parameterized queries (prevent SQL injection)
- Hash passwords with bcrypt/argon2
- Use HTTPS everywhere
- Rate limit API endpoints
- Sanitize output (prevent XSS)

## Database

- Index frequently queried columns
- Avoid N+1 queries
- Use transactions for multi-step operations
- Soft delete over hard delete

## Patterns

```typescript
// Service layer pattern
class UserService {
  constructor(
    private readonly userRepo: UserRepository,
    private readonly emailService: EmailService
  ) {}

  async createUser(data: CreateUserDto): Promise<User> {
    const user = await this.userRepo.create(data);
    await this.emailService.sendWelcome(user);
    return user;
  }
}

// Repository pattern
interface UserRepository {
  create(data: CreateUserDto): Promise<User>;
  findById(id: string): Promise<User | null>;
  update(id: string, data: UpdateUserDto): Promise<User>;
  delete(id: string): Promise<void>;
}
```

## Testing

- Test API contracts (request/response shape)
- Use in-memory DB for fast tests
- Mock external services only
- Test auth/authz separately
