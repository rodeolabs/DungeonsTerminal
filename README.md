# 🏰 DungeonsTerminal

A browser-based text adventure RPG that combines D&D 5E mechanics with RuneScape lore, powered by AI.

## 🎮 Game Features

- **AI Dungeon Master**: Intelligent game master powered by DeepSeek R1
- **D&D 5E Mechanics**: Authentic tabletop RPG experience
- **RuneScape World**: Explore the rich lore of Gielinor
- **Real-time Gameplay**: Live multiplayer interactions
- **Natural Language**: Interact using plain English commands

## 🛠️ Tech Stack

- **Frontend**: Modern web interface with real-time updates
- **Backend**: Supabase (PostgreSQL + Edge Functions)
- **AI**: DeepSeek API (V3 + R1 models)
- **Database**: PostgreSQL with vector search capabilities
- **Deployment**: Supabase Edge Runtime + GitHub Actions

## 🚀 Getting Started

### Prerequisites
- Node.js 18+
- Docker (for local Supabase)
- Supabase CLI
- Git

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/rodeolabs/DungeonsTerminal.git
   cd DungeonsTerminal
   ```

2. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your API keys
   ```

3. **Start local Supabase**
   ```bash
   supabase start
   ```

4. **Access local development**
   - Database: http://localhost:54323
   - API: http://localhost:54321

### Deployment

1. **Link to production**
   ```bash
   supabase link --project-ref hibotimfemudqgormdyg
   ```

2. **Deploy schema changes**
   ```bash
   supabase db push
   ```

3. **Deploy Edge Functions**
   ```bash
   supabase functions deploy
   ```

## 📚 Documentation

- **[CLAUDE.md](CLAUDE.md)**: Complete project architecture and guidance
- **[TODO.md](TODO.md)**: Development roadmap and progress
- **[.env.example](.env.example)**: Environment configuration template

## 🔧 Development Workflow

### Local Development
```bash
# Start local stack
supabase start

# Create new migration
supabase migration new feature_name

# Reset database with all migrations
supabase db reset

# Generate types
supabase gen types typescript --local > types/database.ts
```

### AI Integration
- **DeepSeek-V3**: Fast responses for dialogue and simple interactions
- **DeepSeek-R1**: Complex reasoning for combat and strategic decisions
- **Cost optimization**: Off-peak pricing and context caching

## 🎯 Project Structure

```
DungeonsTerminal/
├── frontend/          # Web interface
├── backend/           # API and business logic
├── database/          # Database utilities
├── types/             # TypeScript type definitions
├── supabase/
│   ├── functions/     # Edge Functions
│   ├── migrations/    # Database migrations
│   └── config.toml    # Supabase configuration
├── tests/             # Test suites
├── README.md          # Project overview
├── CLAUDE.md          # Development guidance
├── TODO.md            # Development roadmap
├── package.json       # Node.js dependencies
├── tsconfig.json      # TypeScript configuration
└── .env.example       # Environment template
```

## 🤝 Contributing

1. Check the [TODO.md](TODO.md) for current tasks
2. Create a feature branch
3. **Automatic feedback**: Claude Code analyzes every push automatically
4. Submit pull request - get AI code review automatically
5. **Manual assistance**: Use GitHub Actions → Claude Code for direct help

### 🤖 Automated AI Feedback

Every code deployment gets **automatic Claude Code analysis**:
- **Code quality review** and bug detection
- **RPG-specific guidance** for D&D 5E mechanics
- **Documentation sync** and updates
- **Deployment readiness** validation
- **Next steps** recommendations

Just push code and get expert AI feedback instantly! 🎯

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🎮 Play the Game

Coming soon! Follow development progress in our [GitHub repository](https://github.com/rodeolabs/DungeonsTerminal).

---

*Built with ❤️ by the DungeonsTerminal team*