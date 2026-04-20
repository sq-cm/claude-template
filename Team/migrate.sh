#!/bin/bash

# Mapping of old person-based names to new role-based names
declare -A migrations=(
  ["Sam - Orchestrator"]="Orchestrator"
  ["Harper - HR Lead"]="HR Lead"
  ["Ryan - Senior Researcher"]="Senior Researcher"
  ["Alex - SEO Specialist"]="SEO Specialist"
  ["Casey - Webflow Developer"]="Webflow Developer"
  ["Cleo - Visual AI Producer"]="Visual AI Producer"
  ["Odin - Opus Advisor"]="Opus Advisor"
  ["Sage - Content Strategist"]="Content Strategist"
  ["Quinn - QA Compliance Reviewer"]="QA Compliance Reviewer"
  ["Finn - Copywriter"]="Copywriter"
  ["Remi - Brand Strategist"]="Brand Strategist"
  ["Ellis - Creative Technologist"]="Creative Technologist"
  ["Nova - Video & Motion Producer"]="Video & Motion Producer"
  ["Axel - Automation Architect"]="Automation Architect"
  ["Juno - Social Media Manager"]="Social Media Manager"
  ["Dex - Analytics & Reporting Specialist"]="Analytics & Reporting Specialist"
  ["Jordan - UX-UI Designer"]="UX-UI Designer"
  ["Tate - Project Manager"]="Project Manager"
  ["Vera - Creative Director"]="Creative Director"
  ["Milo - Amazon Stores Specialist"]="Amazon Stores Specialist"
)

for old_name in "${!migrations[@]}"; do
  new_name="${migrations[$old_name]}"
  
  if [ -d "$old_name" ]; then
    echo "Migrating: $old_name → $new_name"
    
    # Create new role-based folder
    mkdir -p "$new_name"
    
    # Copy persona file with new name
    old_file=$(ls "$old_name"/*.md 2>/dev/null | head -1)
    if [ -f "$old_file" ]; then
      # Generate role-based filename from role name (e.g., "SEO Specialist" → "seo-specialist.md")
      role_slug=$(echo "$new_name" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')
      cp "$old_file" "$new_name/$role_slug.md"
    fi
  fi
done

echo "Migration complete!"
