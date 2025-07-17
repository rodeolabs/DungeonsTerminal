# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Always comment your code and use logging.
Use Supabase MCP for backend related tasks.
We use both local and hosted Supabase for development workflow.
Supabase project_id: "hibotimfemudqgormdyg"
Use Context7 MCP to find technical documentation.
All API keys can be found in the root .env file.
Never use mock implementations or fallbacks.
Do not use Emojis in the frontend.
Always keep the TODO.md in root updated.
Use the logging console we implemented to get logs.
Use detailled todo lists, step by step.
Structured output comes from the AI API directly, no need to sanitize.
We use this for DnD data: https://github.com/nick-aschenbach/dnd-data//
And one for RuneScape locations, NPCs and quests and perhaps lore.

## Project Overview

Dungeon Terminal is a browser-based text adventure RPG that combines D&D 5E mechanics with RuneScape lore. Players interact through natural language commands processed by an AI Dungeon Master (DeepSeek R1) with a comprehensive Supabase backend.

## Architecture Overview

### Frontend
- **Browser-based interface**: Text-based adventure game UI
- **Real-time interactions**: WebSocket connections for live gameplay
- **Responsive design**: Works on desktop and mobile devices

### Backend Stack
- **Supabase**: Primary backend platform providing:
  - **PostgreSQL Database**: Player data, game state, world information
  - **Vector Database**: Embeddings for semantic search and AI context
  - **Real-time subscriptions**: Live game state updates
  - **Authentication**: Player account management
  - **Storage**: Game assets and user-generated content
  - **Edge Functions**: Server-side game logic and AI integration

### AI Integration
- **DeepSeek R1**: Primary AI Dungeon Master
  - Natural language processing for player commands
  - Dynamic story generation and world building
  - Character interaction and dialogue
  - Combat and skill resolution
- **Vector Search**: Semantic search through game lore and context
- **Embeddings**: Store game world knowledge for AI context

### Game Data Sources
- **D&D 5E Mechanics**: https://github.com/nick-aschenbach/dnd-data/
- **RuneScape Lore**: https://github.com/Astrect/runescape-api
- **Custom World Building**: Hybrid universe combining both systems

### Development Workflow
- **Local Development**: Supabase CLI with local stack (localhost:54323)
- **Hosted Production**: Supabase project `hibotimfemudqgormdyg`
- **Database Migrations**: Version-controlled schema changes
- **Edge Functions**: TypeScript functions deployed to Supabase Edge Runtime

## Technical Implementation

### Supabase Setup
```bash
# Local development
supabase start                    # Start local stack
supabase status                   # Check service status
supabase db reset                 # Reset database with migrations

# Production deployment
supabase link --project-ref hibotimfemudqgormdyg
supabase db push                  # Deploy schema changes
supabase functions deploy         # Deploy edge functions
```

### Database Schema
- **Players**: User accounts, character stats, inventory
- **Game Sessions**: Active game states, player locations
- **World Data**: Locations, NPCs, quests, lore
- **Vector Embeddings**: Semantic search data for AI context
- **Game Events**: Action logs, combat results, story progression

### Edge Functions
- **AI Dungeon Master**: Process player commands via DeepSeek R1
- **Vector Search**: Semantic search for game context
- **Game Logic**: Combat resolution, skill checks, world interactions
- **Real-time Updates**: WebSocket handlers for live gameplay

### Vector Database Usage
- **Semantic Search**: Find relevant lore and context for AI responses
- **Player Intent**: Understand natural language commands
- **World Knowledge**: Store and retrieve game world information
- **Story Continuity**: Maintain context across game sessions

### API Integration
- **DeepSeek R1**: Primary AI for natural language processing
- **D&D 5E API**: Character sheets, spells, monsters
- **RuneScape API**: Locations, quests, NPCs
- **Supabase APIs**: Database operations, authentication, storage

### Local vs Hosted Development

**Local Development (Recommended for Development):**
- **URL**: http://localhost:54323 (Supabase Studio)
- **Database**: postgresql://postgres:postgres@127.0.0.1:54322/postgres
- **Benefits**: Instant feedback, offline work, free development
- **Use for**: Schema changes, testing, development

**Hosted Production:**
- **Project ID**: hibotimfemudqgormdyg
- **Region**: West EU (London)
- **Benefits**: Production-ready, scalable, global CDN
- **Use for**: Live game deployment, user testing

**Migration Workflow:**
1. Develop locally with `supabase start`
2. Create migrations with `supabase migration new`
3. Test changes with `supabase db reset`
4. Deploy to production with `supabase db push`
5. Deploy edge functions with `supabase functions deploy`

## GitHub Integration with Claude Code

We have set up GitHub Actions integration with Claude Code that allows you to:

1. **Remote Development**: Run Claude Code commands directly from GitHub
2. **Collaborative Coding**: Share development tasks via GitHub workflows
3. **Version Control**: All Claude-generated code changes are automatically committed
4. **CI/CD Integration**: Combine Claude assistance with automated testing and deployment

### How to Use:

1. Go to your GitHub repository: https://github.com/rodeolabs/DungeonsTerminal
2. Navigate to Actions > Claude Code
3. Click "Run workflow"
4. Enter your request for Claude (e.g., "Create a player character table", "Add authentication middleware")
5. Claude will process your request and commit changes directly to the repository

### Benefits:

- Work from anywhere without local setup
- Maintain full git history of AI-assisted development
- Integrate with your existing GitHub workflow
- Collaborate with team members on AI-generated code
- Automatic code review through pull requests
