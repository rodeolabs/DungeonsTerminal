# D&D/RuneScape Hybrid Architecture Plan

## Core Philosophy

**Game Systems = D&D 5E** | **World Lore = RuneScape (Gielinor)**

- All mechanics, combat, character progression use D&D 5E rules
- All locations, NPCs, quests, and lore draw from RuneScape universe
- AI acts as "RuneScape-informed D&D Dungeon Master"

## Data Architecture

### Keep Separate & Pure

**D&D Data (dnd-data library):**
- Spells, monsters, items, classes, races
- Used as-is, no modifications
- Source of truth for all game mechanics

**RuneScape Data (custom tables):**
- Locations, NPCs, quests, lore
- Stored in separate database tables
- Provides world context and narrative foundation

### Current Database Schema Analysis

**Already Implemented (D&D focused):**
- `characters` - D&D character sheets
- `spells` - D&D spell system
- `items` - D&D equipment
- `combat_encounters` - D&D combat mechanics
- `ai_memories` - AI context storage

**RuneScape Data Gaps:**
- `locations` table exists but needs RuneScape location data
- `npcs` table exists but needs RuneScape NPC personalities
- `quests` table exists but needs RuneScape quest storylines
- Missing: `rs_lore`, `rs_timeline`, `rs_factions`

## Implementation Strategy

### Phase 1: Data Foundation
1. **Populate RuneScape locations** in existing `locations` table
   - Major cities: Lumbridge, Varrock, Falador, Ardougne
   - Regions: Misthalin, Asgarnia, Kandarin, Morytania
   - Dungeons: Catacombs, Stronghold, etc.

2. **Add RuneScape NPCs** to existing `npcs` table
   - Key figures: Hans, Duke Horacio, King Roald
   - Shopkeepers with RuneScape personalities
   - Quest givers with established backstories

3. **Create RuneScape quest content** in existing `quests` table
   - Adapt classic quests: Cook's Assistant, Dragon Slayer
   - Maintain D&D skill checks and combat mechanics
   - Use RuneScape lore for objectives and rewards

### Phase 2: AI Integration
1. **Lore-informed AI prompts**
   - Feed RuneScape location descriptions to AI
   - Use established NPC personalities
   - Reference RuneScape timeline and events

2. **Context enhancement**
   - Store RuneScape lore in `ai_memories` table
   - Create semantic search for lore retrieval
   - Build contextual prompts for each location

### Phase 3: Content Expansion
1. **Advanced quest systems**
   - Multi-part RuneScape quest lines
   - Faction relationships (Zaros, Saradomin, etc.)
   - God Wars and historical events

2. **Dynamic content generation**
   - AI creates new content within RuneScape constraints
   - Procedural events using established lore
   - Player-driven narrative within world rules

## Technical Implementation

### Data Sources
- **D&D Data**: npm package `dnd-data` (33,000+ entries)
- **RuneScape Data**: Manual curation + RuneScape Wiki API
- **AI Context**: Structured prompts with lore constraints

### Integration Layer
```javascript
// Example: AI prompt with RuneScape context
const generateAIPrompt = (action, character) => {
  const location = getRunescapeLocation(character.current_location);
  const lore = getLocationLore(location);
  
  return `
    You are a D&D Dungeon Master in ${location.name}, Gielinor.
    
    Location Context: ${lore.description}
    Notable NPCs: ${lore.npcs.join(', ')}
    Historical Events: ${lore.history}
    
    Player Action: "${action}"
    
    Respond with D&D mechanics but RuneScape world knowledge.
    Use skill checks, saving throws, and combat as per D&D 5E.
  `;
};
```

### Database Schema Extensions
```sql
-- Add RuneScape context to existing tables
ALTER TABLE locations ADD COLUMN rs_region TEXT;
ALTER TABLE locations ADD COLUMN rs_kingdom TEXT;
ALTER TABLE locations ADD COLUMN rs_era TEXT;

ALTER TABLE npcs ADD COLUMN rs_personality_type TEXT;
ALTER TABLE npcs ADD COLUMN rs_faction TEXT;
ALTER TABLE npcs ADD COLUMN rs_lore_context TEXT;

-- New lore management table
CREATE TABLE rs_lore_entries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  category TEXT NOT NULL, -- 'gods', 'history', 'factions', 'events'
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  era TEXT, -- 'first_age', 'second_age', etc.
  related_locations TEXT[],
  related_npcs TEXT[],
  importance_level INTEGER DEFAULT 1,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## Roadmap

### Immediate (Week 1-2)
- [ ] Populate core RuneScape locations (Lumbridge, Varrock, Falador)
- [ ] Add key NPCs with RuneScape personalities
- [ ] Create starter quests (Cook's Assistant, Sheep Shearer)

### Short-term (Month 1)
- [ ] Expand to major regions (Asgarnia, Kandarin, Morytania)
- [ ] Implement lore-informed AI prompts
- [ ] Add faction and god relationships

### Long-term (Month 2+)
- [ ] Advanced quest lines (Dragon Slayer, Monkey Madness)
- [ ] Dynamic content generation within lore constraints
- [ ] Player-driven narrative events

## Benefits of This Approach

1. **Familiar World**: Players recognize locations and NPCs
2. **Rich Lore**: Thousands of hours of established content
3. **Consistent Mechanics**: Pure D&D 5E rules prevent confusion
4. **AI Constraints**: Lore provides creative boundaries for AI
5. **Expandable**: Easy to add new RuneScape content over time
6. **Legal Safety**: Using lore inspiration, not copying game systems

## Success Metrics

- Player engagement with familiar RuneScape locations
- AI generates lore-consistent content
- D&D mechanics work seamlessly with RuneScape world
- Quest completion rates match expectations
- Community contributes RuneScape lore knowledge

---

*Next Steps: Begin Phase 1 implementation with core location and NPC data population.*