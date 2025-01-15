import { useEffect, useState } from 'react'
import { Button, Image, MantineProvider } from '@mantine/core';
import '@mantine/core/styles.css';
import ucfLogo from '/src/assets/ucfLogo.png';
import dncDocument from '/src/assets/dncDocument.pdf';
import sixtyDocument from '/src/assets/60pageDocument.pdf';
import finalDocument from '/src/assets/finalDocument.pdf';
import CrewmateBio from './CrewmateBio';
import roleReveal from '/src/assets/roleReveal.png';

function App() {
  const [sus, setSus] = useState(false);
  const [enteredCode, setEnteredCode] = useState('');
  const secretCodeword = 'sus';

  const crewmates = [
    {
      name: 'Juni Yeom',
      major: 'Computer Science',
      color: 'red',
    },
    {
      name: 'Joshua Yu',
      major: 'Computer Engineering',
      color: 'yellow',
    },
    {
      name: 'Michael Meyers',
      major: 'Electrical Engineering',
      color: 'purple',
    },
    {
      name: 'Kevin Kurian',
      major: 'Computer Engineering',
      color: 'green',
    },
    {
      name: 'Srinilai Kankipati',
      major: 'Computer Engineering',
      color: 'blue',
    },
  ]

  useEffect(() => {
    const handleKeydown = (event) => {
      const { key } = event;
      setEnteredCode((prevCode) => prevCode + key.toLowerCase());
    };

    window.addEventListener('keydown', handleKeydown);

    return () => {
      window.removeEventListener('keydown', handleKeydown);
    };
  }, []);
  useEffect(() => {
    if (enteredCode.includes(secretCodeword)) {
      // Call your function here
      // For example, toggle the 'sus' state
      console.log("SUS DETECTED")
      setSus(true);
      setEnteredCode('');
    }
  }, [enteredCode]);

  return (
    <MantineProvider>
      <div style={{ backgroundImage: sus ? `url(${roleReveal})` : 'none', backgroundSize: 'cover', backgroundRepeat: 'no-repeat', backgroundPosition: 'center', height: '135vh' }}>
        <div className={`w-3/4 m-auto flex items-center flex-col ${sus ? 'text-white' : ''}`}>
          <h1>AI-Powered Digital Audio Mixer</h1>
          <h2>"MISTER MIXER"</h2>
          <Image className="w-24" src={ucfLogo} alt="UCF Logo" />
          <h2>ECE Senior Design – Group 14</h2>
          <hr className="w-full" />
          <div>
            <h2>Description</h2>
            <p>We aim to create a low-cost audio mixer that integrates cutting-edge techniques from audio engineering, offering capabilities not found in current devices. This project will deepen our understanding of audio engineering and result in a practical, high-performance product. By combining general computing with mixers, MISTER MIXER will empower musicians to produce a powerful device at a fraction of the cost of existing consumer options.</p>
          </div>
          <hr className="w-full" />
          <div>
            {
              sus
            ? <h3>Crewmates</h3>
            : <h3>Team Members</h3>
            }
            {
              sus
                ? <div className="flex flex-row space-x-12">
                  {crewmates.map(crewmate => <CrewmateBio crewmateInfo={crewmate} key={crewmate.name} />)}
                </div>
                : <ul>
                  <li>Juni Yeom, Computer Science</li>
                  <li>Joshua Yu, Computer Engineering</li>
                  <li>Michael Meyers, Electrical Engineering</li>
                  <li>Kevin Kurian, Computer Engineering</li>
                  <li>Srinilai Kankipati, Computer Engineering</li>
                </ul>
            }
          </div>
          <hr className="w-full" />
          <div>
            <h2>Documents</h2>
            <Button component="a" href={dncDocument} target="_blank">Divide and Conquer</Button>
            <Button component="a" href={sixtyDocument} target="_blank">60 Page Document</Button>
            <Button component="a" href={finalDocument} target="_blank">Final Document</Button>
            <Button component="a" href="https://www.youtube.com/watch?v=SC1ow58E5GI" target="_blank">Demo Video</Button>

          </div>
          <hr className="w-full" />
          <div>
            <h3>Committee Members</h3>
            <ul>
              <li>John Aedo</li>
              <li>Mark Maddox</li>
              <li>Saleem Sahawneh</li>
              <li>Mikhael Wasfy</li>
              <li>Enxia Zhang</li>
            </ul>
          </div>

          <p className="text-gray-500 text-sm">Website under construction. Product under development. Direct all sales questions to sales@maestro.mix</p>
        </div>
      </div>
    </MantineProvider>
  )
}

export default App
