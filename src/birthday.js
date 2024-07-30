
import { load } from 'cheerio';

const bf = Bun.file("./tmp/drawing.svg");
const content = await bf.text();
const $ = load(content);

const style = $('#person_1').attr('style');
$('#person_3').attr('style', style.replace('display:none;', ''));
console.log($.xml());
