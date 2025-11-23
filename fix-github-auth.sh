#!/bin/bash

echo "🔐 GitHub Authentication Fix"
echo "============================"
echo ""
echo "You have two options:"
echo ""
echo "1. Personal Access Token (PAT) - Quick & Easy"
echo "2. SSH Key - More Secure, One-Time Setup"
echo ""
read -p "Choose option (1 or 2): " choice

if [ "$choice" = "1" ]; then
    echo ""
    echo "📝 Steps to create a Personal Access Token:"
    echo ""
    echo "1. Go to: https://github.com/settings/tokens"
    echo "2. Click 'Generate new token (classic)'"
    echo "3. Name: 'Goal App Deploy'"
    echo "4. Select scope: 'repo'"
    echo "5. Click 'Generate token'"
    echo "6. COPY THE TOKEN (you won't see it again!)"
    echo ""
    read -p "Enter your GitHub username: " username
    read -p "Enter your repository name: " repo
    read -p "Paste your Personal Access Token: " token
    echo ""
    echo "🔧 Setting up remote..."
    git remote remove origin 2>/dev/null
    git remote add origin "https://${token}@github.com/${username}/${repo}.git"
    echo "✅ Remote configured!"
    echo ""
    echo "📤 Pushing to GitHub..."
    git push -u origin main
    
elif [ "$choice" = "2" ]; then
    echo ""
    echo "🔑 Generating SSH key..."
    read -p "Enter your email: " email
    
    if [ ! -f ~/.ssh/id_ed25519 ]; then
        ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519 -N ""
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/id_ed25519
        echo ""
        echo "✅ SSH key generated!"
    else
        echo "✅ SSH key already exists!"
    fi
    
    echo ""
    echo "📋 Your public key (copy this):"
    echo "================================"
    cat ~/.ssh/id_ed25519.pub
    echo "================================"
    echo ""
    echo "📝 Now:"
    echo "1. Go to: https://github.com/settings/keys"
    echo "2. Click 'New SSH key'"
    echo "3. Paste the key above"
    echo "4. Click 'Add SSH key'"
    echo ""
    read -p "Press Enter after adding the key to GitHub..."
    
    read -p "Enter your GitHub username: " username
    read -p "Enter your repository name: " repo
    
    echo ""
    echo "🔧 Setting up remote..."
    git remote remove origin 2>/dev/null
    git remote add origin "git@github.com:${username}/${repo}.git"
    echo "✅ Remote configured!"
    echo ""
    echo "📤 Pushing to GitHub..."
    git push -u origin main
else
    echo "❌ Invalid choice"
    exit 1
fi

echo ""
echo "🎉 Done! Your code is now on GitHub!"
echo "Next: Deploy to Vercel at https://vercel.com"
