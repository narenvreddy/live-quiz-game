import { useEffect, useRef } from "react";
import { GamePhase } from "../backend";
import { useSoundManager } from "./useSoundManager";

export function usePhaseSounds(phase: string | undefined) {
  const { play } = useSoundManager();
  const prevPhaseRef = useRef<string | null>(null);

  useEffect(() => {
    const currentPhaseKey = phase ?? null;

    if (currentPhaseKey === prevPhaseRef.current) return;
    prevPhaseRef.current = currentPhaseKey;

    if (currentPhaseKey === GamePhase.answering) {
      play("optionsReveal");
    }
  }, [phase, play]);
}
