import { useState } from 'react'
import { Button, Image, MantineProvider } from '@mantine/core';
import '@mantine/core/styles.css';
import ucfLogo from '/src/assets/ucfLogo.png';
import dncDocument from '/src/assets/dncDocument.pdf';

function App() {
  return (
    <MantineProvider>
      <div className="w-3/4 m-auto flex items-center flex-col">
        <h1>AI-Powered Digital Audio Mixer</h1>
        <h2>"MISTER MIXER"</h2>
        <Image className="w-24" src={ucfLogo} alt="UCF Logo"/>
        <h2>ECE Senior Design – Group 14</h2>
        <hr className="w-full" />
        <div>
          <h2>Description</h2>
          <p>We aim to create a low-cost audio mixer that integrates cutting-edge techniques from audio engineering, offering capabilities not found in current devices. This project will deepen our understanding of audio engineering and result in a practical, high-performance product. By combining general computing with mixers, MISTER MIXER will empower musicians to produce a powerful device at a fraction of the cost of existing consumer options.</p>
        </div>
        <hr className="w-full" />
        <div>
          <h2>Documents</h2>
          <Button component="a" href={dncDocument} target="_blank">Divide and Conquer (pending approval)</Button>
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
        <hr className="w-full" />
        <div>
          <h3>Team Members</h3>
          <ul>
            <li>Juni Yeom, Computer Science</li>
            <li>Joshua Yu, Computer Engineering</li>
            <li>Michael Meyers, Electrical Engineering</li>
            <li>Kevin Kurian, Computer Engineering</li>
            <li>Srinilai Kankipati, Computer Engineering</li>
          </ul>
        </div>
        <p className="text-gray-500 text-sm">Website under construction. Product under development. Direct all sales questions to sales@maestro.mix</p>
      </div>
    </MantineProvider>
  )
}

export default App
