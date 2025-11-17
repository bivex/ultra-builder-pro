## Serena Command Reference

### get_symbols_overview

**Purpose**: Get file structure without reading full content

**Parameters**:
```typescript
{
  relative_path: string  // Path to file
}
```

**Returns**:
```typescript
{
  symbols: [
    {
      name: string,        // Symbol name
      kind: string,        // "Class", "Function", "Method", etc.
      line: number,        // Starting line number
      children?: Symbol[]  // Nested symbols
    }
  ]
}
```

**Token Cost**: ~500-800 (vs 15K-50K for Read)

---

### find_symbol

**Purpose**: Find and optionally read symbol body

**Parameters**:
```typescript
{
  name_path: string,      // "ClassName" or "ClassName/methodName"
  relative_path?: string, // File path (omit for project-wide search)
  depth?: number,         // 0=symbol only, 1=children, 2=grandchildren
  include_body?: boolean, // true=include code, false=signature only
  substring_matching?: boolean  // true=partial name match
}
```

**Returns**:
```typescript
{
  symbols: [
    {
      name: string,
      kind: string,
      line: number,
      body?: string,      // If include_body=true
      signature?: string  // If include_body=false
    }
  ]
}
```

**Token Cost**: ~1K-3K (depending on symbol size)

---

### find_referencing_symbols

**Purpose**: Find all places where a symbol is used

**Parameters**:
```typescript
{
  name_path: string,
  relative_path: string   // File where symbol is defined
}
```

**Returns**:
```typescript
{
  references: [
    {
      file: string,       // File containing reference
      line: number,       // Line number
      snippet: string,    // Code context around reference
      symbol: string      // Containing symbol name
    }
  ]
}
```

**Token Cost**: ~5K for 50 references (vs 50K for Grep+Read all files)

---

### rename_symbol

**Purpose**: Safely rename symbol across entire codebase

**Parameters**:
```typescript
{
  name_path: string,      // Current symbol name
  relative_path: string,  // File where defined
  new_name: string        // New symbol name
}
```

**Returns**:
```typescript
{
  renamed: number,        // Number of references updated
  files: string[]         // Files modified
}
```

**Safety**: 0% error rate (vs 30% for Grep+Edit)

---

### Memory System Commands

#### write_memory

```typescript
mcp__serena__write_memory(
  "memory-name",
  `Content in markdown format`
)
```

#### read_memory

```typescript
mcp__serena__read_memory("memory-name")
```

#### list_memories

```typescript
mcp__serena__list_memories()
```

#### delete_memory

```typescript
mcp__serena__delete_memory("memory-name")
```

---

