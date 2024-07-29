
import { load } from 'cheerio';

const bf = Bun.file("/apps/alegria/tmp/drawing.svg");
const content = await bf.text();
const $ = load(content);

console.log($('#person_1').text())
