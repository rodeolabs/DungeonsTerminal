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

Dungeon Terminal is a browser-based text adventure RPG that combines D&D 5E mechanics with RuneScape lore. Players interact through natural language commands processed by an AI Dungeon Master (DeepSeek R1) with a Supabase backend.
