import { Card, Image } from "@mantine/core";
import green from './assets/crewmates/green.png';
import blue from './assets/crewmates/blue.png';
import red from './assets/crewmates/red.png';
import purple from './assets/crewmates/purple.png';
import yellow from './assets/crewmates/yellow.png';

function CrewmateBio({crewmateInfo}) {
  const colors = {
    green, blue, red, purple, yellow
  }
  return (
    <div>
      <Image className="w-24" src={colors[crewmateInfo.color]} />
      <h4>{crewmateInfo.name}</h4>
      <p>{crewmateInfo.major}</p>
    </div>
  )
}

export default CrewmateBio;