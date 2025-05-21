# 🎮 ShadowSwap

> A dual-character mind-bending mini puzzle game made with Lua + LOVE2D.

[![GitHub release](https://img.shields.io/github/release/KKNecmi/ThirdPerson-Revamped?include_prereleases=&sort=semver&color=blue)](https://github.com/KKNecmi/ThirdPerson-Revamped/releases/)
[![License](https://img.shields.io/badge/License-GPLv3-blue)](#license)
[![issues - ThirdPerson-Revamped](https://img.shields.io/github/issues/KKNecmi/ThirdPerson-Revamped?color=darkgreen)](https://github.com/KKNecmi/ThirdPerson-Revamped/issues)

---

## :dart: Game Idea

- A **light character** appears in the **upper half** of the screen  
- A **shadow character** moves in the **bottom half**  
- They move **simultaneously**, but one moves in the **opposite direction**  
- Goal: Reach the **correct goal tiles** with both characters at the same time  
- A level-based concept designed to **challenge your brain with mirrored movement**

---

## :pushpin: Project Name
**ShadowSwap**

---

## :video_game: Controls

| Key | Action |
|-----|--------|
| ↑ ↓ ← → | Move both characters at the same time |
| Enter | Skip transition screens |
| Mouse | Click menu buttons |

---

## :bulb: Technologies Used

- **Lua**
- **LOVE2D (version 11.x)** – 2D Game Engine
- Sprite drawing and animation
- Level parsing via `.json` map files (`levels/*.json`)

---

## :gift: Bonus Features

- Multi-level system (`levels/1.json`, `2.json`, etc.)
- Win & Death transitions (`win.json`, `lose.json`)
- Support for animated `.gif` or `.png` sprite sheets
- (Planned) Time-based scoring, star ratings, and speedrun mode

---

## 📂 How to Run the Game

### 🔹 1. Run using `.love` file
```bash
love ShadowSwap.love
