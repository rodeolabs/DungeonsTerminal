-- Initial RPG schema for DungeonsTerminal
-- Combines D&D 5E mechanics with RuneScape lore

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "vector";

-- Players table (user accounts)
CREATE TABLE players (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE NOT NULL,
    username TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    is_active BOOLEAN DEFAULT TRUE,
    settings JSONB DEFAULT '{}'::jsonb
);

-- Characters table (player characters)
CREATE TABLE characters (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    player_id UUID REFERENCES players(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    class TEXT NOT NULL, -- D&D 5E classes
    level INTEGER DEFAULT 1,
    experience INTEGER DEFAULT 0,
    
    -- D&D 5E stats
    strength INTEGER DEFAULT 10,
    dexterity INTEGER DEFAULT 10,
    constitution INTEGER DEFAULT 10,
    intelligence INTEGER DEFAULT 10,
    wisdom INTEGER DEFAULT 10,
    charisma INTEGER DEFAULT 10,
    
    -- Health and resources
    max_hp INTEGER DEFAULT 10,
    current_hp INTEGER DEFAULT 10,
    armor_class INTEGER DEFAULT 10,
    
    -- RuneScape skills
    attack_level INTEGER DEFAULT 1,
    defense_level INTEGER DEFAULT 1,
    strength_level INTEGER DEFAULT 1,
    hitpoints_level INTEGER DEFAULT 10,
    ranged_level INTEGER DEFAULT 1,
    prayer_level INTEGER DEFAULT 1,
    magic_level INTEGER DEFAULT 1,
    cooking_level INTEGER DEFAULT 1,
    woodcutting_level INTEGER DEFAULT 1,
    fletching_level INTEGER DEFAULT 1,
    fishing_level INTEGER DEFAULT 1,
    firemaking_level INTEGER DEFAULT 1,
    crafting_level INTEGER DEFAULT 1,
    smithing_level INTEGER DEFAULT 1,
    mining_level INTEGER DEFAULT 1,
    herblore_level INTEGER DEFAULT 1,
    agility_level INTEGER DEFAULT 1,
    thieving_level INTEGER DEFAULT 1,
    slayer_level INTEGER DEFAULT 1,
    farming_level INTEGER DEFAULT 1,
    runecrafting_level INTEGER DEFAULT 1,
    hunter_level INTEGER DEFAULT 1,
    construction_level INTEGER DEFAULT 1,
    
    -- Character state
    current_location TEXT DEFAULT 'lumbridge',
    gold INTEGER DEFAULT 0,
    inventory JSONB DEFAULT '[]'::jsonb,
    equipment JSONB DEFAULT '{}'::jsonb,
    active_quests JSONB DEFAULT '[]'::jsonb,
    completed_quests JSONB DEFAULT '[]'::jsonb,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Locations table (game world)
CREATE TABLE locations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL,
    description TEXT NOT NULL,
    region TEXT NOT NULL, -- RuneScape regions
    coordinates JSONB, -- x, y coordinates
    connections JSONB DEFAULT '[]'::jsonb, -- connected locations
    npcs JSONB DEFAULT '[]'::jsonb, -- NPCs in this location
    items JSONB DEFAULT '[]'::jsonb, -- Items available
    danger_level INTEGER DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- NPCs table
CREATE TABLE npcs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    location_id UUID REFERENCES locations(id),
    npc_type TEXT NOT NULL, -- merchant, quest_giver, enemy, etc.
    level INTEGER DEFAULT 1,
    stats JSONB DEFAULT '{}'::jsonb,
    dialogue JSONB DEFAULT '[]'::jsonb,
    shop_items JSONB DEFAULT '[]'::jsonb,
    quest_data JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Items table
CREATE TABLE items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    item_type TEXT NOT NULL, -- weapon, armor, consumable, quest, etc.
    rarity TEXT DEFAULT 'common',
    value INTEGER DEFAULT 0,
    stackable BOOLEAN DEFAULT FALSE,
    stats JSONB DEFAULT '{}'::jsonb, -- damage, defense, bonuses
    requirements JSONB DEFAULT '{}'::jsonb, -- level requirements
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Quests table
CREATE TABLE quests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL,
    description TEXT NOT NULL,
    quest_type TEXT DEFAULT 'main',
    difficulty TEXT DEFAULT 'novice',
    requirements JSONB DEFAULT '{}'::jsonb,
    rewards JSONB DEFAULT '{}'::jsonb,
    steps JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Game sessions table (active games)
CREATE TABLE game_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    character_id UUID REFERENCES characters(id) ON DELETE CASCADE,
    session_data JSONB DEFAULT '{}'::jsonb,
    last_action TEXT,
    last_location TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    is_active BOOLEAN DEFAULT TRUE
);

-- Game events table (action log)
CREATE TABLE game_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID REFERENCES game_sessions(id) ON DELETE CASCADE,
    character_id UUID REFERENCES characters(id) ON DELETE CASCADE,
    event_type TEXT NOT NULL, -- combat, dialogue, movement, etc.
    event_data JSONB NOT NULL,
    ai_response JSONB, -- DeepSeek response data
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Vector embeddings for AI context
CREATE TABLE game_embeddings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_type TEXT NOT NULL, -- location, npc, quest, lore
    content_id UUID, -- reference to related table
    content_text TEXT NOT NULL,
    embedding VECTOR(1536), -- OpenAI embedding size
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX idx_characters_player_id ON characters(player_id);
CREATE INDEX idx_characters_location ON characters(current_location);
CREATE INDEX idx_game_sessions_character_id ON game_sessions(character_id);
CREATE INDEX idx_game_sessions_active ON game_sessions(is_active);
CREATE INDEX idx_game_events_session_id ON game_events(session_id);
CREATE INDEX idx_game_events_type ON game_events(event_type);
CREATE INDEX idx_game_embeddings_type ON game_embeddings(content_type);
CREATE INDEX idx_npcs_location ON npcs(location_id);

-- Create vector similarity search index
CREATE INDEX idx_game_embeddings_vector ON game_embeddings USING ivfflat (embedding vector_cosine_ops);

-- Enable Row Level Security
ALTER TABLE players ENABLE ROW LEVEL SECURITY;
ALTER TABLE characters ENABLE ROW LEVEL SECURITY;
ALTER TABLE game_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE game_events ENABLE ROW LEVEL SECURITY;

-- RLS policies for players
CREATE POLICY "Users can view their own profile" ON players
    FOR SELECT USING (auth.uid()::text = id::text);

CREATE POLICY "Users can update their own profile" ON players
    FOR UPDATE USING (auth.uid()::text = id::text);

-- RLS policies for characters
CREATE POLICY "Users can view their own characters" ON characters
    FOR SELECT USING (auth.uid()::text = player_id::text);

CREATE POLICY "Users can create their own characters" ON characters
    FOR INSERT WITH CHECK (auth.uid()::text = player_id::text);

CREATE POLICY "Users can update their own characters" ON characters
    FOR UPDATE USING (auth.uid()::text = player_id::text);

-- RLS policies for game sessions
CREATE POLICY "Users can view their own game sessions" ON game_sessions
    FOR SELECT USING (
        auth.uid()::text = (
            SELECT player_id::text FROM characters WHERE id = character_id
        )
    );

CREATE POLICY "Users can create their own game sessions" ON game_sessions
    FOR INSERT WITH CHECK (
        auth.uid()::text = (
            SELECT player_id::text FROM characters WHERE id = character_id
        )
    );

CREATE POLICY "Users can update their own game sessions" ON game_sessions
    FOR UPDATE USING (
        auth.uid()::text = (
            SELECT player_id::text FROM characters WHERE id = character_id
        )
    );

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Add updated_at triggers
CREATE TRIGGER update_players_updated_at BEFORE UPDATE ON players
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_characters_updated_at BEFORE UPDATE ON characters
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_game_sessions_updated_at BEFORE UPDATE ON game_sessions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();