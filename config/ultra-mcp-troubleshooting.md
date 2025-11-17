# MCP Troubleshooting - Issues and Solutions

**Ultra Builder Pro 4.0** - Common MCP issues, debugging steps, and configuration reference.

---

## Common Issues and Solutions

### Issue 1: MCP Tool Not Responding

**Symptoms**:
- Tool call hangs indefinitely
- Timeout errors after long wait
- No response from MCP server

**Diagnosis**:
```bash
# Check MCP server status
/mcp
```

**Solutions**:

1. **Restart Claude Code**
   - Close and reopen Claude Code
   - MCP servers will reinitialize

2. **Check .mcp.json configuration**
   - Verify server command is correct
   - Ensure all arguments are valid
   - Check environment variables

3. **Verify server installation**
   ```bash
   # For Serena MCP
   npx @codingame/serena-mcp-server --version

   # For other servers, check installation command
   ```

4. **Check network connectivity**
   - Some MCP servers require internet access
   - Verify firewall settings

---

### Issue 2: Serena Returns No Results

**Symptoms**:
- `find_symbol` returns empty array
- `rename_symbol` says "symbol not found"
- Expected results not returned

**Diagnosis Steps**:

**Step 1: Verify file path is correct**
```typescript
// Use Glob to verify file exists
Glob(pattern="**/user.ts")
// Returns list of matching files
```

**Step 2: Check symbol name spelling**
```typescript
// Try substring matching for fuzzy search
mcp__serena__find_symbol(
  name_path="Auth",
  substring_matching=true  // Will match "Authentication", "AuthService", etc.
)
```

**Step 3: Verify symbol is in specified file**
```typescript
// Get overview of file first
mcp__serena__get_symbols_overview(
  relative_path="src/services/user.ts"
)
// Check if symbol exists in the output
```

**Solutions**:

1. **Use correct relative path** (from project root)
   ```typescript
   // Wrong: Absolute path
   mcp__serena__find_symbol(relative_path="/Users/name/project/src/")

   // Correct: Relative path
   mcp__serena__find_symbol(relative_path="src/")
   ```

2. **Use substring matching for fuzzy search**
   ```typescript
   mcp__serena__find_symbol(
     name_path="Component",
     relative_path="src/",
     substring_matching=true
   )
   ```

3. **Check symbol name path syntax**
   - Absolute: `/TopLevelSymbol`
   - Relative: `ParentSymbol/ChildSymbol`
   - Simple: `SymbolName` (matches anywhere)

---

### Issue 3: MCP Output Too Large (>10k tokens)

**Symptoms**:
- Warning about output size
- Truncated responses
- Incomplete results

**Root Cause**: Query is too broad and returns too many results.

**Solutions**:

**Solution 1: Be more specific - Narrow search scope**
```typescript
// Wrong: Too broad
mcp__serena__find_symbol(
  name_path="Component",
  relative_path=""  // Searches entire codebase
)

// Correct: Specific directory
mcp__serena__find_symbol(
  name_path="Component",
  relative_path="src/components/"  // Narrow scope
)
```

**Solution 2: Use focused queries - Don't include_body unless needed**
```typescript
// Wrong: Includes all implementations (large output)
mcp__serena__find_symbol(
  include_body=true,
  depth=2
)

// Correct: Metadata only first
mcp__serena__find_symbol(
  include_body=false,
  depth=1
)
// Then read specific symbols with include_body=true
```

**Solution 3: Paginate results - Process incrementally**
- Get overview first
- Identify specific symbols of interest
- Read them individually

**Solution 4: Filter by symbol type**
```typescript
mcp__serena__find_symbol(
  name_path="Auth",
  relative_path="src/",
  include_kinds=[5]  // Only classes (LSP kind 5)
)
```

**Common LSP Symbol Kinds**:
- 5 = Class
- 6 = Method
- 12 = Function
- 13 = Variable

---

### Issue 4: Context7 Library Not Found

**Symptoms**:
- `resolve-library-id` returns no results
- Library ID doesn't work with `get-library-docs`
- "Library not found" error

**Diagnosis**:
```typescript
// Try resolving the library
mcp__context7__resolve-library-id(libraryName="react")
// If returns empty or no matches, library may not be supported
```

**Solutions**:

**Solution 1: Try different library name variations**
```typescript
// Try all of these variations
mcp__context7__resolve-library-id(libraryName="react")
mcp__context7__resolve-library-id(libraryName="reactjs")
mcp__context7__resolve-library-id(libraryName="facebook/react")
```

**Solution 2: Check if library is supported by Context7**
- Context7 focuses on popular, well-documented libraries
- Smaller or newer libraries may not be available

**Solution 3: Use WebFetch as fallback**
```typescript
// If Context7 doesn't have it, use WebFetch
WebFetch(
  url="https://official-library-docs.com",
  prompt="Extract API documentation for hooks"
)
```

---

### Issue 5: Performance Measurement Setup (Playwright Skill + Lighthouse)

**Note**: chrome-devtools MCP has been removed. Use Playwright Skill (CLI-based) for E2E testing and Lighthouse CLI for performance measurement.

**Symptoms**:
- Performance measurement fails
- No Core Web Vitals data
- Lighthouse command not found

**Diagnosis**:
```bash
# Check if Lighthouse is installed
lighthouse --version

# Check if Playwright is installed
npx playwright --version
```

**Solutions**:

**Solution 1: Install Lighthouse CLI**
```bash
# Global installation
npm install -g lighthouse

# Verify installation
lighthouse --version
```

**Solution 2: Use Playwright CLI for navigation (optional, for pages requiring login)**
```bash
# Start development server with Playwright
npx playwright codegen http://localhost:3000
# Or run existing tests to navigate to page
npx playwright test --headed
```

**Solution 3: Measure with Lighthouse CLI**
```bash
# Run Lighthouse for Core Web Vitals
lighthouse http://localhost:3000 \
  --only-categories=performance \
  --output=json \
  --output-path=./lighthouse-report.json

# Parse results
cat lighthouse-report.json | jq '.audits | {
  LCP: ."largest-contentful-paint".numericValue,
  TBT: ."total-blocking-time".numericValue,
  CLS: ."cumulative-layout-shift".numericValue
}'
```

**Solution 4: Check if server is running**
- Ensure development server is running
- Verify URL is accessible
- For protected pages, use Playwright CLI tests to navigate with login first

---

## Configuration Reference

### Project-Scoped Configuration

**File**: `.mcp.json` (in project root)

**Benefits**:
- Team consistency (everyone uses same MCP servers)
- Version controlled (checked into git)
- Automatic for all team members

**Example**:
```json
{
  "mcpServers": {
    "serena": {
      "command": "npx",
      "args": ["-y", "@codingame/serena-mcp-server"],
      "env": {}
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-context7"],
      "env": {}
    }
  }
}
```

**Configuration Fields**:
- `command`: Executable command (e.g., "npx", "node", "python")
- `args`: Array of arguments passed to command
- `env`: Environment variables (object with key-value pairs)

---

### User-Scoped Configuration

**File**: `~/.config/Claude/mcp.json` (global for user)

**Use for**: Personal MCP servers not needed by team

**Example**:
```json
{
  "mcpServers": {
    "personal-tool": {
      "command": "node",
      "args": ["/path/to/personal-mcp-server.js"],
      "env": {
        "API_KEY": "your-api-key"
      }
    }
  }
}
```

**Configuration Precedence**:
1. Project-scoped (`.mcp.json`) - Highest precedence
2. User-scoped (`~/.config/Claude/mcp.json`) - Lower precedence

If same server name in both, project-scoped wins.

---

### Verifying MCP Configuration

**Check MCP server status**:
```bash
/mcp
```

**Expected output**:
- List of configured servers
- Status (running/stopped)
- Available tools per server

**Common configuration issues**:

1. **Wrong command path**
   ```json
   // Wrong
   "command": "serena-mcp-server"  // Not in PATH

   // Correct
   "command": "npx"  // Use npx to auto-install
   ```

2. **Missing arguments**
   ```json
   // Wrong
   "args": ["@codingame/serena-mcp-server"]  // Missing -y flag

   // Correct
   "args": ["-y", "@codingame/serena-mcp-server"]
   ```

3. **Invalid JSON syntax**
   - Missing commas
   - Trailing commas
   - Unescaped quotes

---

## Debugging Best Practices

### 1. Start Simple

Test with simplest possible query first:

```typescript
// Test if server is responding at all
mcp__serena__get_symbols_overview(relative_path="package.json")

// If works, gradually increase complexity
mcp__serena__find_symbol(name_path="/", relative_path="src/")
```

---

### 2. Use Built-in Tools for Verification

Before using MCP, verify with built-in tools:

```typescript
// Verify file exists
Glob(pattern="**/myfile.ts")

// Verify content
Grep(pattern="function myFunction", type="ts")

// Then use MCP for semantic operations
mcp__serena__find_symbol(name_path="myFunction")
```

---

### 3. Check MCP Server Logs

**Location** (macOS): `~/Library/Logs/Claude/mcp-server-*.log`

**What to look for**:
- Connection errors
- Timeout messages
- Parsing errors
- Tool invocation logs

---

### 4. Test MCP Server Standalone

Some MCP servers can be tested outside Claude Code:

```bash
# Test Serena MCP standalone
npx @codingame/serena-mcp-server
```

---

## MCP Performance Optimization

### Tips for Faster MCP Responses

1. **Narrow search scope**
   - Use `relative_path` to restrict searches
   - Be specific with `name_path`

2. **Avoid unnecessary body reads**
   - Set `include_body=false` when only need metadata
   - Use `depth=0` when don't need children

3. **Use parallel queries when possible**
   - Multiple independent MCP calls in single message
   - Faster than sequential calls

4. **Cache results mentally**
   - If already got overview, don't fetch again
   - Reuse symbol information from previous queries

---

## When to Choose Built-in vs MCP

**Use Built-in Tools**:
- Reading single file → Read
- String search → Grep
- Finding files by name → Glob
- Small project (<50 files) → All built-in tools sufficient

**Use MCP Tools**:
- Semantic search (understand code structure) → Serena
- Cross-file refactoring → Serena
- Official library docs → Context7
- Browser automation + E2E testing → Playwright Skill (CLI-based)
- **Core Web Vitals measurement → Playwright Skill + Lighthouse CLI**

**Decision Matrix**:

| Task | Built-in Tool | MCP Tool | Winner |
|------|---------------|----------|--------|
| Read file | Read | - | Built-in (faster) |
| Find text | Grep | - | Built-in (faster) |
| Find function | Grep | Serena find_symbol | MCP (semantic) |
| Rename everywhere | Edit (manual) | Serena rename_symbol | MCP (safe) |
| Get docs | WebFetch | Context7 | MCP (focused) |

**Remember**: MCP tools are enhancements, not replacements. Always try built-in tools first, use MCP when semantic understanding or specialized capabilities are needed.
