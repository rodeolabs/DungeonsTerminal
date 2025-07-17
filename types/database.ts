// Generated TypeScript types for Supabase
// Run: npm run types:generate to update this file

export interface Database {
  public: {
    Tables: {
      // Types will be generated here by Supabase CLI
      // This is a placeholder file for TypeScript configuration
    }
  }
}

// Placeholder types for development
export interface Player {
  id: string;
  email: string;
  username: string;
  created_at: string;
  updated_at: string;
  is_active: boolean;
  settings: any;
}

export interface Character {
  id: string;
  player_id: string;
  name: string;
  class: string;
  level: number;
  experience: number;
  // D&D 5E stats
  strength: number;
  dexterity: number;
  constitution: number;
  intelligence: number;
  wisdom: number;
  charisma: number;
  // Health and resources
  max_hp: number;
  current_hp: number;
  armor_class: number;
  // Character state
  current_location: string;
  gold: number;
  inventory: any[];
  equipment: any;
  active_quests: any[];
  completed_quests: any[];
  created_at: string;
  updated_at: string;
}