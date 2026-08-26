const $ = (selector, scope = document) => scope.querySelector(selector);
const $$ = (selector, scope = document) => [...scope.querySelectorAll(selector)];

// Full-screen 8-bit intro: 8 beats at exactly 120 BPM, then the story opens.
const pixelIntro = $('.pixel-intro');
const pixelHeart = $('.pixel-heart');
const heartMap = [
  '..LL...DD..',
  '.LLLR.RDDDD',
  'LLRRRRRDDDD',
  'LRRRRRRRRDD',
  '.RRRRRRRRR.',
  '..RRRRRRR..',
  '...RRRRR...',
  '....RRR....',
  '.....R.....',
];
heartMap.join('').split('').forEach((pixel) => {
  const cell = document.createElement('i');
  if (pixel !== '.') {
    cell.className = `pixel-heart__cell${pixel === 'L' ? ' pixel-heart__cell--light' : pixel === 'D' ? ' pixel-heart__cell--dark' : ''}`;
  }
  pixelHeart.appendChild(cell);
});

let introClosed = false;
let introBeat = 0;
const introBars = $$('.pixel-intro__progress i');
const introInterval = setInterval(() => {
  if (introBeat < introBars.length) introBars[introBeat].classList.add('is-lit');
  introBeat += 1;
  if (introBeat >= introBars.length) closeIntro();
}, 500);

function closeIntro() {
  if (introClosed) return;
  introClosed = true;
  clearInterval(introInterval);
  pixelIntro.classList.add('is-leaving');
  document.documentElement.classList.remove('intro-loading');
  setTimeout(() => pixelIntro.remove(), 800);
}
$('.pixel-intro__open').addEventListener('click', closeIntro);
document.addEventListener('keydown', (event) => {
  if (!introClosed && (event.key === 'Enter' || event.key === ' ' || event.key === 'Escape')) closeIntro();
});

// Reveal content gently as it enters the viewport.
const revealObserver = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      entry.target.classList.add('is-visible');
      revealObserver.unobserve(entry.target);
    }
  });
}, { threshold: 0.12, rootMargin: '0px 0px -40px' });
$$('.reveal').forEach((element) => revealObserver.observe(element));

// Exact live counter from the first day together (Vladivostok time).
const togetherSince = new Date('2024-12-27T00:00:00+10:00');
function updateCounter() {
  const elapsed = Math.max(0, Date.now() - togetherSince.getTime());
  const days = Math.floor(elapsed / 86400000);
  const hours = Math.floor((elapsed / 3600000) % 24);
  const minutes = Math.floor((elapsed / 60000) % 60);
  $('[data-counter="days"]').textContent = days.toLocaleString('ru-RU');
  $('[data-counter="hours"]').textContent = String(hours).padStart(2, '0');
  $('[data-counter="minutes"]').textContent = String(minutes).padStart(2, '0');
}
updateCounter();
setInterval(updateCounter, 30000);

// Music control. Playback starts only after a user gesture, as browsers require.
const audio = $('#our-song');
const soundButton = $('.sound-button');
const toast = $('.toast');
let toastTimer;
function showToast(message) {
  toast.textContent = message;
  toast.classList.add('is-visible');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => toast.classList.remove('is-visible'), 2600);
}
soundButton.addEventListener('click', async () => {
  try {
    if (audio.paused) {
      await audio.play();
      soundButton.classList.add('is-playing');
      soundButton.setAttribute('aria-pressed', 'true');
      $('.sound-button__label').textContent = 'Пауза';
      showToast('Играет наша песня ♡');
    } else {
      audio.pause();
      soundButton.classList.remove('is-playing');
      soundButton.setAttribute('aria-pressed', 'false');
      $('.sound-button__label').textContent = 'Наша песня';
    }
  } catch (_) {
    showToast('Не удалось включить музыку. Попробуй ещё раз ♡');
  }
});

// Extra memories.
const moreButton = $('.more-button');
const moreGallery = $('.gallery--more');
moreButton.addEventListener('click', () => {
  const isOpen = moreGallery.classList.toggle('is-open');
  moreGallery.setAttribute('aria-hidden', String(!isOpen));
  $('span', moreButton).textContent = isOpen ? 'Скрыть воспоминания' : 'Показать ещё воспоминания';
  $('b', moreButton).textContent = isOpen ? '−' : '＋';
});

// Personal letter reveal.
const letterCard = $('.letter__card');
const letterButton = $('.letter__button');
letterButton.addEventListener('click', () => {
  const isOpen = letterCard.classList.toggle('is-open');
  $('span', letterButton).textContent = isOpen ? 'Свернуть письмо' : 'Открыть письмо';
  $('i', letterButton).textContent = isOpen ? '♥' : '♡';
});

// Gallery lightbox with arrows and keyboard navigation.
const lightbox = $('.lightbox');
const lightboxImage = $('img', lightbox);
let galleryItems = [];
let currentIndex = 0;
function refreshGallery() { galleryItems = $$('.gallery__item'); }
function showPhoto(index) {
  refreshGallery();
  currentIndex = (index + galleryItems.length) % galleryItems.length;
  const item = galleryItems[currentIndex];
  lightboxImage.src = item.dataset.full;
  lightboxImage.alt = $('img', item).alt;
  $('.lightbox__meta span').textContent = $('span', item)?.textContent || 'Наш момент';
  $('.lightbox__meta b').textContent = `${String(currentIndex + 1).padStart(2, '0')} / ${String(galleryItems.length).padStart(2, '0')}`;
}
refreshGallery();
galleryItems.forEach((item) => item.addEventListener('click', () => {
  showPhoto(galleryItems.indexOf(item));
  lightbox.showModal();
  document.body.style.overflow = 'hidden';
}));
$('.lightbox__close').addEventListener('click', () => lightbox.close());
$('.lightbox__nav--prev').addEventListener('click', () => showPhoto(currentIndex - 1));
$('.lightbox__nav--next').addEventListener('click', () => showPhoto(currentIndex + 1));
lightbox.addEventListener('click', (event) => { if (event.target === lightbox) lightbox.close(); });
lightbox.addEventListener('close', () => { document.body.style.overflow = ''; lightboxImage.src = ''; });
document.addEventListener('keydown', (event) => {
  if (!lightbox.open) return;
  if (event.key === 'ArrowLeft') showPhoto(currentIndex - 1);
  if (event.key === 'ArrowRight') showPhoto(currentIndex + 1);
});

// Soft pointer light on desktop.
const glow = $('.cursor-glow');
if (matchMedia('(pointer:fine)').matches) {
  const loveCursor = $('.love-cursor');
  window.addEventListener('pointermove', (event) => {
    glow.animate({ left: `${event.clientX}px`, top: `${event.clientY}px` }, { duration: 1000, fill: 'forwards' });
    loveCursor.animate({ left: `${event.clientX}px`, top: `${event.clientY}px` }, { duration: 180, fill: 'forwards' });
  });
  $$('.gallery__item, .chapter__photo').forEach((item) => {
    item.addEventListener('mouseenter', () => loveCursor.classList.add('is-view'));
    item.addEventListener('mouseleave', () => loveCursor.classList.remove('is-view'));
  });
}

// Cinematic scrolling: progress, restrained parallax and gently drifting hero.
let scrollTicking = false;
function updateScrollEffects() {
  const y = window.scrollY;
  const max = document.documentElement.scrollHeight - innerHeight;
  $('.scroll-progress i').style.transform = `scaleX(${max ? y / max : 0})`;
  const heroPhoto = $('.hero__photo');
  if (y < innerHeight * 1.2) heroPhoto.style.translate = `0 ${y * .13}px`;
  $$('[data-parallax]').forEach((item) => {
    const rect = item.parentElement.getBoundingClientRect();
    if (rect.bottom > 0 && rect.top < innerHeight) item.style.translate = `0 ${rect.top * Number(item.dataset.parallax)}px`;
  });
  const timeline = $('.timeline');
  if (timeline) {
    const rect = timeline.getBoundingClientRect();
    const progress = Math.max(0, Math.min(1, -rect.top / Math.max(1, timeline.offsetHeight - innerHeight)));
    const rail = $('.timeline__rail i');
    if (rail) rail.style.setProperty('--rail-y', `${progress * Math.max(0, timeline.offsetHeight - 320)}px`);
  }
  $$('.gallery__item').forEach((item, index) => {
    const rect = item.getBoundingClientRect();
    if (rect.bottom > 0 && rect.top < innerHeight) {
      const center = (rect.top + rect.height / 2 - innerHeight / 2) / innerHeight;
      $('img', item).style.translate = `0 ${center * -18 * (index % 2 ? 1 : -1)}px`;
    }
  });
  scrollTicking = false;
}
window.addEventListener('scroll', () => {
  if (!scrollTicking) { requestAnimationFrame(updateScrollEffects); scrollTicking = true; }
}, { passive: true });
updateScrollEffects();

// Magnetic buttons give controls a subtle premium pull on desktop.
if (matchMedia('(pointer:fine)').matches) {
  $$('.more-button, .letter__button, .sound-button, .hero__scroll, .love-burst').forEach((button) => {
    button.addEventListener('pointermove', (event) => {
      const rect = button.getBoundingClientRect();
      button.style.translate = `${(event.clientX - rect.left - rect.width/2) * .1}px ${(event.clientY - rect.top - rect.height/2) * .13}px`;
    });
    button.addEventListener('pointerleave', () => button.style.translate = '0 0');
  });
}

// Section-aware ambient color and headline tracking.
const ambientObserver = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (!entry.isIntersecting) return;
    const dark = entry.target.matches('.timeline,.cinema,.footer');
    document.body.style.setProperty('--ambient', dark ? '#2b1b17' : '#f6f0e8');
  });
}, { threshold: .45 });
$$('section,.footer').forEach(section => ambientObserver.observe(section));

// Tactile tilt for the love notes.
if (matchMedia('(pointer:fine)').matches) {
  $$('[data-tilt]').forEach((card) => {
    card.addEventListener('pointermove', (event) => {
      const rect = card.getBoundingClientRect();
      const rx = ((event.clientY - rect.top) / rect.height - .5) * -7;
      const ry = ((event.clientX - rect.left) / rect.width - .5) * 7;
      card.style.transform = `rotateX(${rx}deg) rotateY(${ry}deg)`;
    });
    card.addEventListener('pointerleave', () => card.style.transform = '');
  });
}

// Tiny heart confetti — local canvas only, lightweight and touch-friendly.
const particleCanvas = $('.love-particles');
let particleDpr = Math.min(devicePixelRatio, 2);
const ctx = particleCanvas.getContext('2d');
let particles = [];
function sizeCanvas() { particleDpr = Math.min(devicePixelRatio, 2); particleCanvas.width = innerWidth*particleDpr; particleCanvas.height = innerHeight*particleDpr; particleCanvas.style.width=`${innerWidth}px`; particleCanvas.style.height=`${innerHeight}px`; }
sizeCanvas(); window.addEventListener('resize', sizeCanvas);
function heartPath(x,y,size,color,rotation){ ctx.save();ctx.translate(x,y);ctx.rotate(rotation);ctx.scale(size/20,size/20);ctx.beginPath();ctx.moveTo(0,6);ctx.bezierCurveTo(-12,-2,-9,-11,-4,-11);ctx.bezierCurveTo(0,-11,0,-7,0,-7);ctx.bezierCurveTo(0,-7,1,-11,5,-11);ctx.bezierCurveTo(11,-11,13,-2,0,6);ctx.fillStyle=color;ctx.fill();ctx.restore(); }
function animateParticles(){ctx.setTransform(1,0,0,1,0,0);ctx.clearRect(0,0,particleCanvas.width,particleCanvas.height);ctx.setTransform(particleDpr,0,0,particleDpr,0,0);particles=particles.filter(p=>p.life>0);particles.forEach(p=>{p.x+=p.vx;p.y+=p.vy;p.vy+=.025;p.rotation+=p.spin;p.life-=.015;ctx.globalAlpha=Math.max(0,p.life);heartPath(p.x,p.y,p.size,p.color,p.rotation)});ctx.globalAlpha=1;if(particles.length)requestAnimationFrame(animateParticles)}
const burstButton = $('.love-burst'); let loveCount=0;
burstButton.addEventListener('click',()=>{loveCount++;$('small',burstButton).textContent=loveCount;const r=burstButton.getBoundingClientRect();for(let i=0;i<28;i++)particles.push({x:r.left+r.width/2,y:r.top+r.height/2,vx:(Math.random()-.5)*7,vy:-Math.random()*6-1,size:7+Math.random()*13,color:['#df3956','#f87582','#e9c7bd'][i%3],rotation:Math.random()*6,spin:(Math.random()-.5)*.15,life:1});requestAnimationFrame(animateParticles);});
