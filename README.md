# BergTech HR Assistant — RAG over internal documents

A retrieval-augmented chatbot that answers HR questions for a fictional
manufacturing company strictly from its internal HR documents, cites the source
of every answer, and returns a fixed fallback sentence instead of inventing
content when retrieval comes back empty.

Coursework for the *LLM & Agentics* module, HS Albstadt-Sigmaringen, May 2026.
Graded 1.0.

## Setup

| Component | Choice |
|---|---|
| Orchestration | n8n with LangChain nodes |
| Vector store | Supabase, PostgreSQL with pgvector, HNSW index, EU region |
| Embeddings | text-embedding-3-small, 1536 dimensions |
| Chat model | gpt-5-mini through an OpenAI Functions agent |
| Chunking | recursive character splitter, 500 characters, 50 overlap |
| Retrieval | top-k 8 |
| Knowledge base | 5 HR documents (onboarding, vacation, compliance, FAQ, offboarding) |

## How it works

Two decoupled paths on one n8n canvas, connected only through the Supabase
`documents` table:

- **Ingestion**, manual trigger: read the HR markdown, split into overlapping
  chunks, embed, write to pgvector.
- **Query**, chat trigger: user question to an agent holding a vector-store tool,
  top-8 chunks, answer with a source reference. Empty retrieval produces a fixed
  refusal, not a guess.

The grounding rule is the point of the project: the assistant may only answer
from the indexed documents. Row-level security limits access to the service role,
anonymous access is blocked, and the service key is never committed.

## Repo map

```
company-docs/hr-set-a/   the knowledge base, Markdown plus the Word originals
workflows/v4.7/          n8n exports, ingestion and query
supabase/                pgvector schema and the match_documents function
docs/                    architecture, an implementation reflection, a walkthrough
PRD.md, CHANGELOG.md     requirements and the build log
```

## Scope and credit

Group project, three people. The pipeline, the workflows, the schema and the
architecture documentation in this repo are my work, 60 of 63 commits;
documentation contributions and the presentation came from the other two team
members. Their submission documents and the individual assessment reports are not
part of this repo.

The company, its documents and its policies are fictional, written for the
exercise. No real company data.
