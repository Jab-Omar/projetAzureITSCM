#!/bin/bash

# 1. Empêcher les messages d'interaction qui bloquent le script
export DEBIAN_FRONTEND=noninteractive

# 2. Mise à jour des dépôts (Indispensable)
sudo apt-get update -y

# 3. Installation d'Apache + outils utiles (curl, git, etc. si besoin)
# On ajoute -y et des options pour forcer la config par défaut
sudo apt-get install -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y apache2

# 4. S'assurer qu'Apache démarre au boot et maintenant
sudo systemctl enable apache2
sudo systemctl start apache2

# --- Code HTML du site web---
cat <<'EOF' > /var/www/html/index.html
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Azure Mission | Omar Jabali</title>
    
    <link rel="icon" type="image/x-icon" href="https://www.microsoft.com/favicon.ico">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    
    <style>
        :root { --az-blue: #0078d4; --neon-cyan: #00f2ff; --itscm-gold: #ffcc00; --terminal-green: #00ff41; }
        
        body { background: #010409; color: white; font-family: 'Segoe UI', sans-serif; min-height: 100vh; margin: 0; overflow-x: hidden; }

        /* --- Intro Impactante --- */
        #intro-screen {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: #000; z-index: 9999; display: flex; align-items: center; justify-content: center;
            flex-direction: column;
        }
        .terminal-box { font-family: 'Consolas', monospace; font-size: 1.2rem; border-left: 3px solid var(--terminal-green); padding-left: 15px; }
        .glitch { font-size: 3rem; font-weight: bold; text-transform: uppercase; position: relative; text-shadow: 0.05em 0 0 rgba(255,0,0,.75), -0.025em -0.05em 0 rgba(0,255,0,.75), 0.025em 0.05em 0 rgba(0,0,255,.75); animation: glitch 500ms infinite; }
        @keyframes glitch { 0% { text-shadow: 0.05em 0 0 rgba(255,0,0,.75), -0.025em -0.05em 0 rgba(0,255,0,.75), 0.025em 0.05em 0 rgba(0,0,255,.75); } 14% { text-shadow: 0.05em 0 0 rgba(255,0,0,.75), -0.025em -0.05em 0 rgba(0,255,0,.75), 0.025em 0.05em 0 rgba(0,0,255,.75); } 15% { text-shadow: -0.05em -0.025em 0 rgba(255,0,0,.75), 0.025em 0.025em 0 rgba(0,255,0,.75), -0.05em -0.05em 0 rgba(0,0,255,.75); } 49% { text-shadow: -0.05em -0.025em 0 rgba(255,0,0,.75), 0.025em 0.025em 0 rgba(0,255,0,.75), -0.05em -0.05em 0 rgba(0,0,255,.75); } 50% { text-shadow: 0.025em 0.05em 0 rgba(255,0,0,.75), 0.05em 0 0 rgba(0,255,0,.75), 0 -0.05em 0 rgba(0,0,255,.75); } 99% { text-shadow: 0.025em 0.05em 0 rgba(255,0,0,.75), 0.05em 0 0 rgba(0,255,0,.75), 0 -0.05em 0 rgba(0,0,255,.75); } 100% { text-shadow: -0.025em 0 0 rgba(255,0,0,.75), -0.025em -0.025em 0 rgba(0,255,0,.75), -0.025em -0.05em 0 rgba(0,0,255,.75); } }

        /* --- Main Content --- */
        #main-content { display: none; background: radial-gradient(circle at center, #0a192f 0%, #000 100%); min-height: 100vh; padding: 40px 20px; }
        .glass-card { background: rgba(255, 255, 255, 0.03); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 35px; padding: 50px; box-shadow: 0 0 100px rgba(0, 120, 212, 0.2); max-width: 900px; margin: auto; }
        .hero-title { font-size: 4rem; font-weight: 900; background: linear-gradient(to right, #fff, var(--az-blue), var(--neon-cyan)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }

        /* --- GIFs Cadrés --- */
        .feature-item { background: rgba(255,255,255,0.05); border-radius: 25px; padding: 30px; cursor: pointer; transition: 0.4s; border-left: 6px solid var(--az-blue); margin-bottom: 25px; }
        .feature-item:hover { background: rgba(255,255,255,0.08); transform: translateY(-5px); }
        .gif-frame { border-radius: 15px; overflow: hidden; margin: 20px 0; border: 2px solid var(--neon-cyan); background: #000; text-align: center; }
        .gif-frame img { width: 100%; height: auto; display: block; object-fit: contain; max-height: 350px; }
        .fun-content { display: none; }
        
        .thank-you-box { background: rgba(255, 204, 0, 0.1); border: 1px solid var(--itscm-gold); border-radius: 15px; padding: 20px; margin-top: 30px; text-align: center; }
    </style>
</head>
<body>

    <div id="intro-screen">
        <div class="glitch mb-4">SYSTEM BREACH</div>
        <div class="terminal-box">
            <div id="terminal-text"></div>
        </div>
    </div>

    <div id="main-content">
        <div class="glass-card animate__animated animate__fadeIn">
            <div class="text-center mb-5">
                <span class="badge bg-success mb-2">PROJET AZURE : CONNECTÉ</span>
                <h1 class="hero-title">Hello Mr Bernair !</h1>
                <p class="fs-4 creator-name">Par <strong>Omar Jabali</strong></p>
                <div style="color: var(--itscm-gold); font-size: 0.95rem; font-weight: bold;">ITSCM – Institut Technique Cardinal Mercier</div>
                <div class="small opacity-75">Promotion Sociale</div>
            </div>

            <div class="feature-item" onclick="toggleCard('iac')">
                <h3><i class="fas fa-magic me-2"></i> L'Infrastructure as Code <span class="badge bg-primary float-end" style="font-size: 0.6rem;">EXPLORE</span></h3>
                <div id="iac" class="fun-content animate__animated animate__fadeIn">
                    <hr>
                    <p><strong>Expertise :</strong> On ne clique plus, on définit. Ce serveur a été déployé via un template JSON. C'est le futur de l'Ops.</p>
                    <p class="text-info"><em>"Quand le script ne marche pas, on sort l'artillerie lourde."</em></p>
                    <div class="gif-frame">
                        <img src="https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExMHRqdDhveDZocHl2b2RucDc1dmt3cGZtb3J1cWp4MWRtcHF3MDVqcCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/901mxGLGQN2PyCQpoc/giphy.gif" alt="Chat tactique">
                    </div>
                </div>
            </div>

            <div class="feature-item" onclick="toggleCard('script')">
                <h3><i class="fas fa-dog me-2"></i> Custom Script Extension <span class="badge bg-primary float-end" style="font-size: 0.6rem;">EXPLORE</span></h3>
                <div id="script" class="fun-content animate__animated animate__fadeIn">
                    <hr>
                    <p><strong>Expertise :</strong> Azure injecte ce script bash à la création de la VM pour transformer une machine vide en serveur web de luxe.</p>
                    <div class="gif-frame">
                        <img src="https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExNXcwbTBmZnF4dng5MmE3Y2xpMmxiMWZ0NnJuajVvdTBibnJjdXRkZiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/Fu3OjBQiCs3s0ZuLY3/giphy.gif" alt="Chien goofy">
                    </div>
                </div>
            </div>

            <div class="thank-you-box animate__animated animate__heartBeat animate__delay-2s">
                <h5 class="text-warning"><i class="fas fa-heart me-2"></i> Mot de Remerciement</h5>
                <p class="mb-0">Merci beaucoup <strong>Mr Bernair</strong> pour ce cours enrichissant et pour votre expertise partagée durant cette formation à l'<strong>ITSCM</strong> !</p>
            </div>

            <div class="mt-5 text-center opacity-25 small">
                © 2026 Omar Jabali | Déploiement Cloud Automatisé
            </div>
        </div>
    </div>

    <script>
        const lines = [
            "> BYPASSING AZURE FIREWALL...",
            "> ACCESSING RESOURCE GROUP 'PROJET-BERNAIR'...",
            "> INJECTING BASH SCRIPT TO UBUNTU...",
            "> OPTIMIZING GIFS FOR MAXIMUM GOOFINESS...",
            "> SYSTEM READY. WELCOME OMAR."
        ];
        let i = 0;
        function showLines() {
            if (i < lines.length) {
                document.getElementById('terminal-text').innerHTML += lines[i] + "<br>";
                i++;
                setTimeout(showLines, 300);
            } else {
                setTimeout(() => {
                    document.getElementById('intro-screen').classList.add('animate__animated', 'animate__fadeOutUp');
                    setTimeout(() => {
                        document.getElementById('intro-screen').style.display = 'none';
                        document.getElementById('main-content').style.display = 'block';
                    }, 500);
                }, 800);
            }
        }
        showLines();

        function toggleCard(id) {
            const el = document.getElementById(id);
            el.style.display = (el.style.display === 'block') ? 'none' : 'block';
        }
    </script>
</body>
</html>
EOF

sudo systemctl restart apache2
