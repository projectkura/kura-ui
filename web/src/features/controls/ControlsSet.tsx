import { cva } from 'class-variance-authority';
import { cn } from '../../lib/cn';
import type { ControlsItem, ControlsOrientation } from '../../types/overlay';

type ControlsSetProps = {
	orientation: ControlsOrientation;
	items: ControlsItem[];
};

const setVariants = cva('flex max-w-[min(42rem,92vw)] gap-2', {
	variants: {
		orientation: {
			row: 'flex-row flex-wrap justify-end',
			column: 'flex-col items-end',
		},
	},
	defaultVariants: {
		orientation: 'row',
	},
});

export default function ControlsSet({ orientation, items }: ControlsSetProps) {
	return (
		<div className={cn(setVariants({ orientation }))}>
			{items.map((item) => (
				<div
					key={`${item.input}:${item.label}`}
					className="group inline-flex min-h-11 items-center gap-2 rounded-full border border-[color:var(--hairline-strong)] bg-[color:var(--paper)]/96 px-2 py-2 text-[0.8125rem] font-semibold tracking-[0.02em] text-[color:var(--ink)] shadow-[0_12px_30px_rgba(6,8,16,0.24)] ring-1 ring-black/4 transition-transform duration-150 ease-[var(--ease-out-expo)] will-change-transform"
				>
					<span className="inline-flex min-w-12 items-center justify-center rounded-full bg-[color:var(--ink)] px-3 py-1.5 font-mono text-[0.75rem] font-semibold uppercase tracking-[0.16em] text-white shadow-[inset_0_1px_0_rgba(255,255,255,0.14)]">
						{item.input}
					</span>
					<span className="pr-2 text-[0.82rem] leading-none text-black/88">
						{item.label}
					</span>
				</div>
			))}
		</div>
	);
}
