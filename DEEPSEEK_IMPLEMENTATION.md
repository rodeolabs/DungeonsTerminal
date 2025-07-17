# DeepSeek API Implementation Guide

## DeepSeek API Overview

DeepSeek provides two powerful AI models optimized for different use cases:

### Models

**1. DeepSeek-V3 (`deepseek-chat`)**
- **Use Case**: General conversation, creative writing, basic game interactions
- **Max Context**: 64K tokens
- **Max Output**: 8K tokens
- **Best For**: Player dialogue, basic story generation, quick responses

**2. DeepSeek-R1 (`deepseek-reasoner`)**
- **Use Case**: Complex reasoning, math, coding, strategic game decisions
- **Max Context**: 64K tokens  
- **Max Output**: 64K tokens
- **Best For**: Combat resolution, complex quest logic, world-building decisions
- **Special Feature**: Chain-of-Thought (CoT) reasoning

## Pricing Strategy (Optimized for RPG)

### Cost Structure (per 1M tokens)
- **Input (Cache Hit)**: $0.14-$0.55 (deepseek-reasoner)
- **Input (Cache Miss)**: $0.27-$0.55 (deepseek-chat)
- **Output**: $1.10-$2.19

### Off-Peak Discount (50-75% off)
- **Time**: UTC 16:30-00:30 (11:30 PM - 7:30 PM EST)
- **Strategy**: Schedule heavy AI processing during off-peak hours

### Cost Optimization for RPG

**1. Context Caching**
- Cache frequently used game world information
- Reuse character descriptions and location data
- 50% cost reduction on cached inputs

**2. Model Selection Strategy**
```javascript
// Use deepseek-chat for simple interactions
if (action.type === 'dialogue' || action.type === 'simple_command') {
  model = 'deepseek-chat';
}

// Use deepseek-reasoner for complex decisions
if (action.type === 'combat' || action.type === 'puzzle' || action.type === 'strategy') {
  model = 'deepseek-reasoner';
}
```

**3. Token Management**
- Limit context to essential game state
- Use structured prompts to reduce token usage
- Implement response caching for common scenarios

## Implementation for DungeonsTerminal

### 1. Supabase Edge Function Setup

```typescript
// supabase/functions/ai-dungeon-master/index.ts
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { OpenAI } from 'https://esm.sh/openai@4.20.1'

const client = new OpenAI({
  apiKey: Deno.env.get('DEEPSEEK_API_KEY')!,
  baseURL: 'https://api.deepseek.com'
})

serve(async (req) => {
  const { action, gameState, playerInput } = await req.json()
  
  // Select model based on action complexity
  const model = getOptimalModel(action)
  
  // Build context with game state
  const context = buildGameContext(gameState)
  
  // Make API call to DeepSeek
  const response = await client.chat.completions.create({
    model: model,
    messages: [
      { role: 'system', content: context },
      { role: 'user', content: playerInput }
    ],
    temperature: 0.7,
    max_tokens: model === 'deepseek-reasoner' ? 32000 : 4000
  })
  
  return new Response(JSON.stringify(response.choices[0].message))
})
```

### 2. Game Context Builder

```typescript
function buildGameContext(gameState: GameState): string {
  return `You are an expert Dungeon Master for DungeonsTerminal, a text-based RPG that combines D&D 5E mechanics with RuneScape lore.

CURRENT GAME STATE:
- Player: ${gameState.player.name} (Level ${gameState.player.level} ${gameState.player.class})
- Location: ${gameState.currentLocation}
- HP: ${gameState.player.hp}/${gameState.player.maxHp}
- Inventory: ${gameState.player.inventory.join(', ')}
- Active Quests: ${gameState.activeQuests.map(q => q.name).join(', ')}

WORLD CONTEXT:
- Setting: Gielinor (RuneScape world) with D&D 5E mechanics
- Available locations: ${gameState.worldData.locations.join(', ')}
- Available NPCs: ${gameState.worldData.npcs.join(', ')}

INSTRUCTIONS:
- Use D&D 5E rules for combat, skills, and magic
- Incorporate RuneScape lore, locations, and characters
- Provide immersive, detailed responses
- Always include game mechanics (dice rolls, skill checks)
- Format responses as JSON with: { "narrative": "...", "gameEffects": {...}, "options": [...] }`;
}
```

### 3. Model Selection Logic

```typescript
function getOptimalModel(action: GameAction): string {
  const complexActions = [
    'combat_resolution',
    'spell_casting',
    'skill_check',
    'puzzle_solving',
    'quest_logic',
    'world_building'
  ];
  
  const simpleActions = [
    'dialogue',
    'movement',
    'inventory',
    'basic_interaction'
  ];
  
  if (complexActions.includes(action.type)) {
    return 'deepseek-reasoner'; // Better for complex reasoning
  }
  
  if (simpleActions.includes(action.type)) {
    return 'deepseek-chat'; // Faster and cheaper for simple tasks
  }
  
  // Default to reasoner for unknown actions
  return 'deepseek-reasoner';
}
```

### 4. Chain-of-Thought for Complex Decisions

```typescript
// For deepseek-reasoner, use structured prompts
const complexPrompt = `
<think>
Consider the following factors:
1. Player's current stats and abilities
2. D&D 5E rules for this situation
3. RuneScape lore and world consistency
4. Potential outcomes and consequences
5. Appropriate difficulty level
</think>

<answer>
Provide the game response in JSON format:
{
  "narrative": "Descriptive text for the player",
  "gameEffects": {
    "hpChange": number,
    "xpGain": number,
    "itemsGained": [],
    "statusEffects": []
  },
  "options": ["Option 1", "Option 2", "Option 3"]
}
</answer>
`;
```

### 5. Caching Strategy

```typescript
// Cache common game elements
const gameCache = new Map();

function getCachedResponse(key: string, context: string) {
  const cacheKey = `${key}:${hashString(context)}`;
  return gameCache.get(cacheKey);
}

function setCachedResponse(key: string, context: string, response: any) {
  const cacheKey = `${key}:${hashString(context)}`;
  gameCache.set(cacheKey, response);
}

// Cache location descriptions, NPC dialogues, common actions
const cachedElements = [
  'location_descriptions',
  'npc_dialogues',
  'item_descriptions',
  'spell_effects'
];
```

### 6. Error Handling and Fallbacks

```typescript
async function callDeepSeek(prompt: string, model: string) {
  try {
    const response = await client.chat.completions.create({
      model: model,
      messages: [{ role: 'user', content: prompt }],
      temperature: 0.7
    });
    
    return response.choices[0].message.content;
  } catch (error) {
    console.error('DeepSeek API Error:', error);
    
    // Fallback to simpler model
    if (model === 'deepseek-reasoner') {
      return await callDeepSeek(prompt, 'deepseek-chat');
    }
    
    // Final fallback to cached response
    return getCachedFallbackResponse(prompt);
  }
}
```

## Performance Optimization

### 1. Batch Processing
- Process multiple simple actions together
- Use off-peak hours for complex world generation
- Implement request queuing for cost optimization

### 2. Token Efficiency
- Use structured prompts with clear sections
- Implement response templates for common actions
- Cache and reuse character/location descriptions

### 3. Real-time vs Batch
- **Real-time**: Player dialogue, simple actions
- **Batch**: World generation, complex quest logic, bulk NPC interactions

## Monitoring and Analytics

```typescript
// Track API usage and costs
const apiMetrics = {
  totalTokensUsed: 0,
  totalCost: 0,
  requestsByModel: {
    'deepseek-chat': 0,
    'deepseek-reasoner': 0
  },
  cacheHitRate: 0
};

function trackApiUsage(model: string, inputTokens: number, outputTokens: number) {
  apiMetrics.totalTokensUsed += inputTokens + outputTokens;
  apiMetrics.requestsByModel[model]++;
  
  // Calculate cost based on current pricing
  const cost = calculateCost(model, inputTokens, outputTokens);
  apiMetrics.totalCost += cost;
}
```

## Recommended Architecture

**For DungeonsTerminal:**
1. **Use deepseek-reasoner** for combat, complex decisions, world-building
2. **Use deepseek-chat** for dialogue, simple interactions, quick responses
3. **Implement aggressive caching** for locations, NPCs, common scenarios
4. **Schedule heavy processing** during off-peak hours (50-75% discount)
5. **Use structured JSON responses** for consistent game state management

This setup gives you the best balance of performance, cost-effectiveness, and game experience quality for your RPG project.