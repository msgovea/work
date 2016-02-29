package com.ciandt.talentos.gconf.backend.dto;

import java.sql.Date;
import java.sql.Timestamp;

import com.ciandt.talentos.gconf.backend.entities.Conferencia;

public class ConferenciaDTO {

	int id;
	String titulo;
	String assunto;
	String organizador;
	Timestamp dataInicio;
	Timestamp dataFim;

	public ConferenciaDTO(int id, String titulo, String assunto,
			String organizador, Timestamp dataInicio, Timestamp dataFim) {
		super();
		this.id = id;
		this.titulo = titulo;
		this.assunto = assunto;
		this.organizador = organizador;
		this.dataInicio = dataInicio;
		this.dataFim = dataFim;

	}

	public ConferenciaDTO(Conferencia entity){
		this.id = entity.getId();
		this.titulo = entity.getTitulo();
		this.assunto = entity.getAssunto();
		this.organizador = entity.getOrganizador();
		this.dataInicio = entity.getDateInicio();
		this.dataFim = entity.getDataFim();
	}
	
	public Conferencia toEntity() {
		return new Conferencia(getId(), getTitulo(), getAssunto(), getOrganizador(), getDataInicio(), getDataFim());
	}
	
	public int getId() {
		return id;
	}

	public String getTitulo() {
		return titulo;
	}

	public String getAssunto() {
		return assunto;
	}

	public String getOrganizador() {
		return organizador;
	}

	public Timestamp getDataInicio() {
		return dataInicio;
	}

	public Timestamp getDataFim() {
		return dataFim;
	}

}
