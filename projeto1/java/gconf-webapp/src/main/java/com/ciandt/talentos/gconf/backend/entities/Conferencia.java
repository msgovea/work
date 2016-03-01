package com.ciandt.talentos.gconf.backend.entities;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.apache.commons.lang3.builder.HashCodeBuilder;
import org.apache.commons.lang3.builder.EqualsBuilder;

@Entity
@Table(name = "GC_CONFERENCIA")
public class Conferencia {
	
	@Id
	@SequenceGenerator(name="GC_CONFERENCIA_SEQ")
	@Column(name="ID", nullable=false)
	private Long id;
	
	@Column(name="TITULO", nullable=false)
	private String titulo;
	
	@Column(name="ASSUNTO", nullable=false)
	private String assunto;
	
	@Column(name="ORGANIZADOR", nullable=false)
	private String organizador;	
	
	@Column(name="DATA_INICIO", nullable=false)
	private Timestamp dataIni;
	
	@Column(name="DATA_FIM", nullable=false)
	private Timestamp dataFim;

	public Conferencia() {};
	
	public Conferencia(Long id, String titulo, String assunto, String organizador, Timestamp dataIni, Timestamp dataFim) {
		this.id = id;
		this.titulo = titulo;
		this.assunto = assunto;
		this.organizador = organizador;
		this.dataIni = dataIni;
		this.dataFim = dataFim;
	}
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getTitulo() {
		return titulo;
	}

	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}

	public String getAssunto() {
		return assunto;
	}

	public void setAssunto(String assunto) {
		this.assunto = assunto;
	}

	public String getOrganizador() {
		return organizador;
	}

	public void setOrganizador(String organizador) {
		this.organizador = organizador;
	}

	public Timestamp getDataIni() {
		return dataIni;
	}

	public void setDataIni(Timestamp dataIni) {
		this.dataIni = dataIni;
	}

	public Timestamp getDataFim() {
		return dataFim;
	}

	public void setDataFim(Timestamp dataFim) {
		this.dataFim = dataFim;
	}

	@Override
	public int hashCode() {
		return new HashCodeBuilder()
				.append(this.getId())
				.toHashCode();
	}

	@Override
	public boolean equals(Object o) {
		if (!(o instanceof Conferencia)) {
			return false;
		}
		return new EqualsBuilder()
				.append(this.getId(), ((Conferencia) o).getId())
				.isEquals();
	}	
	
	
	
	
}
