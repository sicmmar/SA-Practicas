import { Component, OnInit } from '@angular/core';
import { environment } from 'src/environments/environment';

@Component({
  selector: 'app-pagina',
  templateUrl: './pagina.component.html',
  styleUrls: ['./pagina.component.scss']
})
export class PaginaComponent implements OnInit {

  constructor() { }

  public contador : number = 0;

  ngOnInit(): void {
    this.cargarData();
  }

  async cargarData(){
    const response = await fetch(environment.ip, {
      method : "GET",
      headers : {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
    });

    const data = await response.json();
    this.contador = data.number;
  }

}
