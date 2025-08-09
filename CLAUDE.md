# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Godot 4.4 game project called "Loop" - appears to be a narrative-driven puzzle/adventure game with dialogue systems and inventory mechanics. The game involves a looping storyline with a character named Tomas and various interactive objects and items.

## Development Commands

Since this is a Godot project, development is primarily done through the Godot Editor:

- **Run Game**: Open project in Godot Editor and press F5 or use the Play button
- **Debug**: Use F6 to run with debugger in Godot Editor
- **Export**: Use Godot's export functionality (Project > Export)

**In-Game Development Shortcuts**:
- `R` key: Soft reset game state (resets interactables and player position)
- `F5` key: Full reset (resets game state + progress)

## Core Architecture

### Autoload Singletons (Global Systems)
- `State`: Manages global game state (minimal - currently only tracks apple status)
- `Global`: Utility functions for global operations
- `DialogueManager`: Handles all dialogue interactions using the Dialogue Manager addon
- `Inventory`: Manages player inventory system with BaseItem resources
- `UiManager`: Controls UI elements and interactions
- `GameManager`: Core game logic controller handling progress, transitions, and game loops

### Key Systems

#### Game Manager (`game/system/game_manager/game_manager.gd`)
- Controls the main game loop and progress tracking
- Manages `tomas_progress` (0-3 progression system)
- Handles soft resets and game state transitions
- Controls room visibility (Workshop, Living Room, Boy Room)
- Processes item delivery to Tomas character

#### Inventory System (`game/system/inventory/inventory.gd`)
- Manages array of `BaseItem` resources
- Supports item expressions (code execution when items are used)
- Provides methods to add/remove/check items

#### Actionable System (`game/helpers/actionable.gd`)
- Universal interaction system for game objects
- Action types: `DIALOGUE`, `CLEANABLE`, `CLAIMABLE`, `MIXED`, `DOOR`, `CHECKITEM`
- Handles item collection, dialogue triggers, and object state changes
- Supports progress-gated activation and highlighting

#### Item System (`game/item/item.gd`)
- `BaseItem` class extends Resource
- Properties: name, description, icon, expression (executable code)
- Items stored as .tres resource files in `game/item/`

### Global Groups
Objects are organized using Godot groups:
- `Interactable`: All interactive objects
- `Player`: Player character
- `BlackBlock`: Screen transition overlay
- `LivingRoom`, `BoyRoom`, `WorkShop`: Room containers
- `OriginObjectContainer`: Default player spawn location

## Project Structure

- `game/scenes/`: Main game scenes
- `game/dialogue/`: Dialogue files (.dialogue) and balloon UI
- `game/system/`: Core game systems (GameManager, Inventory, UI)
- `game/helpers/`: Utility classes (Actionable, TransitionArea, Camera)
- `game/item/`: Item resource definitions
- `addons/dialogue_manager/`: Third-party dialogue system addon

## Dialogue System

Uses the Dialogue Manager addon for Godot. Dialogue files are in custom .dialogue format:
- Main dialogue: `game/dialogue/loop.dialogue`
- Character dialogues stored per character
- Balloon UI customized in `game/dialogue_ballon/`

## Code Conventions

- GDScript naming: snake_case for variables/functions, PascalCase for classes
- System logging: Each system has `system_name` string for consistent debug output
- Resource-based items: All items are Godot Resources (.tres files)
- Group-based object management: Uses Godot's group system extensively