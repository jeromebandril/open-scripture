{{flutter_js}}
{{flutter_build_config}}


// this animation is AI generated
const style = document.createElement('style');
style.innerHTML = `
  @keyframes page-turn-3 {
    0% {
      transform: rotateY(0deg);
      opacity: 1;
      z-index: 3; /* Starts on the right, ready to flip */
    }
    33.33% {
      transform: rotateY(-180deg);
      opacity: 1;
      z-index: 3; /* Finishes flipping to the left */
    }
    66.66% {
      transform: rotateY(-180deg);
      opacity: 1;
      z-index: 2; /* Sits flat on the left while the next page flips on top of it */
    }
    66.67% {
      transform: rotateY(-180deg);
      opacity: 0; /* Instantly hides once covered by the next page */
      z-index: 1;
    }
    68% {
      transform: rotateY(0deg);
      opacity: 0; /* Snaps back to the right side while invisible */
      z-index: 1;
    }
    95% {
      transform: rotateY(0deg);
      opacity: 0; /* Stays invisible, waiting for its turn */
      z-index: 1;
    }
    100% {
      transform: rotateY(0deg);
      opacity: 1; /* Fades back in just in time to loop */
      z-index: 3;
    }
  }

  @keyframes loading-dots {
    to { width: 1.25em; }
  }

  /* Main Container */
  #splash-container {
    display: flex;
    height: 100vh;
    width: 100vw;
    align-items: center;
    justify-content: center;
    flex-direction: column;
    background-color: #FAFAFA;
    color: #555555;
    font-family: "Georgia", serif;
    font-size: 22px;
    position: fixed;
    top: 0;
    left: 0;
    z-index: 9999;
  }

  /* Bible Icon Styling */
  .bible-icon {
    display: flex;
    width: 60px;
    height: 40px;
    position: relative;
    margin-bottom: 25px;
    perspective: 250px; /* 3D Depth */
    transform-style: preserve-3d;
  }

  /* The Permanent Center Spine Line */
  .spine-line {
    position: absolute;
    left: 50%;
    top: 0;
    width: 2px;
    height: 100%;
    background-color: #555555;
    transform: translateX(-50%);
    z-index: 10; /* Always sits on top of all pages */
  }

  /* Static background book base */
  .bible-icon::before,
  .bible-icon::after {
    content: "";
    position: absolute;
    top: 0;
    width: 50%;
    height: 100%;
    background-color: #EAEAEA;
    border: 2px solid #555555;
    box-sizing: border-box;
    z-index: 1; /* Below the flipping pages */
  }
  .bible-icon::before {
    left: 0;
    border-radius: 4px 0 0 4px;
    border-right: none;
  }
  .bible-icon::after {
    right: 0;
    border-radius: 0 4px 4px 0;
    border-left: none;
  }

  .page {
    width: 50%;
    height: 100%;
    position: absolute;
    right: 0;
    background-color: #FAFAFA;
    border: 2px solid #555555;
    border-left: none;
    border-radius: 0 4px 4px 0;
    box-sizing: border-box;
    transform-origin: left center;
    animation: page-turn-3 3.6s infinite linear; 
    will-change: transform, opacity; 
  }

  /* timing synchronization 
  .page:nth-child(2) {
    animation-delay: 0s; /* Page 1 starts immediately */
  }
  .page:nth-child(3) {
    animation-delay: 1.2s; /* Page 2 starts after 1.2s */
  }
  .page:nth-child(4) {
    animation-delay: 2.4s; /* Page 3 starts after 2.4s */
  }

  /* Dots Styling */
  .dots {
    display: inline-block;
    width: 0;
    overflow: hidden;
    vertical-align: bottom;
    animation: loading-dots 1.6s steps(4, end) infinite;
    text-align: left;
  }
`;
document.head.appendChild(style);

// Create the splash screen
const splashscreen = document.createElement('div');
splashscreen.id = 'splash-container';

splashscreen.innerHTML = `
  <div class="bible-icon">
    <div class="spine-line"></div>
    <div class="page"></div>
    <div class="page"></div>
    <div class="page"></div>
  </div>
  <div class="status-text">
    Opening Scriptures<span class="dots">...</span>
  </div>
`;

document.body.appendChild(splashscreen);

// Initialize the Flutter engine
_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine({});
    
    // splashscreen.remove();
    // style.remove();
    
    // await appRunner.runApp();
  }
});