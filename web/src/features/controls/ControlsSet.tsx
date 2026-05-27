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
					className="group inline-flex min-h-9 items-center gap-2 rounded-full border border-white/10 bg-[color:var(--midnight-2)] px-1.5 py-1.5 text-[0.8125rem] font-semibold tracking-[0.02em] shadow-[0_8px_24px_rgba(0,0,0,0.5)] transition-transform duration-150 ease-[var(--ease-out-expo)] will-change-transform"
				>
					<span className="inline-flex min-w-10 items-center justify-center rounded-full bg-white px-2.5 py-1 font-mono text-[0.72rem] font-bold uppercase tracking-[0.12em] text-[color:var(--midnight)] shadow-[0_1px_3px_rgba(0,0,0,0.4)]">
						{item.input}
					</span>
					<span className="pr-2 text-[0.8rem] leading-none text-white/80">
						{item.label}
					</span>
				</div>
			))}
		</div>
	);
}
